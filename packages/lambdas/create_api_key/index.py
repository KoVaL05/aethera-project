import os
import boto3
import uuid
import base64
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities.data_classes import AppSyncResolverEvent
from aws_lambda_powertools.utilities.data_classes.appsync_resolver_event import (
    AppSyncIdentityCognito,
)
from mypy_boto3_kms.client import KMSClient
from mypy_boto3_dynamodb.client import DynamoDBClient

from common.error_handlers_appsync import createError, ErrorType
from common.dynamodb_parser import python_to_dynamo


logger = Logger()
kms_client: KMSClient = boto3.client("kms")
dynamodb_client: DynamoDBClient = boto3.client("dynamodb")


def encrypt(kms_alias: str, data: str):
    response = kms_client.encrypt(KeyId=kms_alias, Plaintext=data.encode())
    logger.info(
        f"The string was encrypted with algorithm {response['EncryptionAlgorithm']}"
    )
    return response["CiphertextBlob"]


def putItem(tableName: str, item: dict):
    return dynamodb_client.put_item(TableName=tableName, Item=item)


def handler(event: dict, context: LambdaContext):
    try:
        logger.info("CONTEXT %s", context)
        resolver_event = AppSyncResolverEvent(event)
        kms_alias = os.environ["kmsApiKeyAliasName"]
        table_name = os.environ["apiKeyTableName"]
        if (
            resolver_event.identity == None
            or type(resolver_event.identity) != AppSyncIdentityCognito
        ):
            logger.error("IDENTITY %s", resolver_event.identity)
            return createError("Unauthorized identity", ErrorType.UNAUTHORIZED)
        key_type, value, timestamp = (
            resolver_event.arguments["type"],
            resolver_event.arguments["value"],
            resolver_event.arguments["timestamp"],
        )

        if next((False for obj in [key_type, value, timestamp] if obj == None), True):
            encrypted = encrypt(kms_alias, value)
            body = {
                "id": str(uuid.uuid4()),
                "userId": resolver_event.identity.sub,
                "keyType": key_type,
                "value": encrypted,
                "createdAt": timestamp,
            }
            result = putItem(
                table_name,
                python_to_dynamo(body),
            )
            if result["ResponseMetadata"]["HTTPStatusCode"] == 200:
                body.update(value=base64.b64encode(encrypted).decode("utf-8"))
                return body

        else:
            return createError("Missing required arguments", ErrorType.BAD_REQUEST)
    except Exception as e:
        logger.error("ERROR %s", e)
        return createError("Unexpected error occured", ErrorType.UNEXPECTED)
