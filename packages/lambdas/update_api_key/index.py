# Standard library imports
import os
import base64

# AWS SDK and related imports
import boto3
from boto3.dynamodb.types import Binary
from mypy_boto3_kms.client import KMSClient
from mypy_boto3_dynamodb.client import DynamoDBClient
from mypy_boto3_dynamodb.type_defs import UpdateItemOutputTypeDef

# AWS Lambda Powertools imports
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities.data_classes import AppSyncResolverEvent
from aws_lambda_powertools.utilities.data_classes.appsync_resolver_event import (
    AppSyncIdentityCognito,
)

# Local application imports
from common.error_handlers_appsync import createError, ErrorType
from common.dynamodb_parser import dynamo_to_python, python_to_dynamo


logger = Logger()
kms_client: KMSClient = boto3.client("kms")
dynamodb_client: DynamoDBClient = boto3.client("dynamodb")


def encrypt(kms_alias: str, data: str):
    response = kms_client.encrypt(KeyId=kms_alias, Plaintext=data.encode())
    logger.info(
        f"The string was encrypted with algorithm {response['EncryptionAlgorithm']}"
    )
    return response["CiphertextBlob"]


def updateItem(
    tableName: str, id: str, uid: str, value: bytes
) -> UpdateItemOutputTypeDef:
    return dynamodb_client.update_item(
        TableName=tableName,
        Key=python_to_dynamo({"id": id}),
        UpdateExpression="SET #v = :new_value",
        ConditionExpression="#u = :user_id",
        ExpressionAttributeNames={"#v": "value", "#u": "userId"},
        ExpressionAttributeValues=python_to_dynamo(
            {":new_value": value, ":user_id": uid}
        ),
        ReturnValues="ALL_NEW",
    )


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

        id, value = resolver_event.arguments["id"], resolver_event.arguments["value"]

        if value:
            encrypted = encrypt(kms_alias, value)
            result = updateItem(table_name, id, resolver_event.identity.sub, encrypted)
            if result["ResponseMetadata"]["HTTPStatusCode"] == 200:
                attributes = dynamo_to_python(result["Attributes"])
                bytes = attributes["value"]
                attributes.update(
                    value=base64.b64encode(
                        bytes.value if isinstance(bytes, Binary) else bytes
                    ).decode("utf-8")
                )
                return attributes
        else:
            return createError("Missing required arguments", ErrorType.BAD_REQUEST)
    except Exception as e:
        logger.error("ERROR %s", e)
        return createError("Unexpected error occured", ErrorType.UNEXPECTED)
