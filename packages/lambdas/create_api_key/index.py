# Standard library imports
import os
import uuid
import base64

# AWS SDK and related imports
import boto3
from mypy_boto3_kms.client import KMSClient
from mypy_boto3_dynamodb.client import DynamoDBClient

# AWS Lambda Powertools imports
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities.data_classes import AppSyncResolverEvent
from aws_lambda_powertools.utilities.data_classes.appsync_resolver_event import (
    AppSyncIdentityCognito,
)

# Local application imports
from common.error_handlers_appsync import createError, ErrorType
from common.dynamodb_parser import python_to_dynamo
from common.kms_handlers import encrypt
from common.dynamodb_handlers import putItem

logger = Logger()

kms_client: KMSClient = boto3.client("kms")
dynamodb_client: DynamoDBClient = boto3.client("dynamodb")


def handler(event: dict, context: LambdaContext):
    try:

        logger.info("CONTEXT %s", context)
        resolver_event = AppSyncResolverEvent(event)
        kms_alias = os.environ["kmsApiKeyAliasName"]
        table_name = os.environ["apiKeyTableName"]
        key_type, value, timestamp = (
            resolver_event.arguments["type"],
            resolver_event.arguments["value"],
            resolver_event.arguments["timestamp"],
        )

        encrypted = encrypt(kms_client, kms_alias, value)
        body = {
            "id": str(uuid.uuid4()),
            "userId": resolver_event.identity.sub,
            "keyType": key_type,
            "value": encrypted,
            "createdAt": timestamp,
        }
        result = putItem(
            dynamodb_client,
            table_name,
            python_to_dynamo(body),
        )
        if result["ResponseMetadata"]["HTTPStatusCode"] == 200:
            body.update(value=base64.b64encode(encrypted).decode("utf-8"))
            return body

    except Exception as e:
        logger.error("ERROR %s", e)
        return createError("Unexpected error occured", ErrorType.UNEXPECTED)
