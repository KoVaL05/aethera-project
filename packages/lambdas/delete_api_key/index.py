# Standard library imports
import os
import base64

# AWS SDK and related imports
import boto3
from boto3.dynamodb.types import Binary

# AWS Lambda Powertools imports
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities.data_classes import AppSyncResolverEvent
from mypy_boto3_dynamodb import DynamoDBClient

# Local application imports
from common.error_handlers_appsync import createError, ErrorType
from common.dynamodb_parser import dynamo_to_python
from common.dynamodb_handlers import deleteApiKey

logger = Logger()
dynamodb_client: DynamoDBClient = boto3.client("dynamodb")


def handler(event: dict, context: LambdaContext):
    try:

        logger.info("CONTEXT %s", context)
        resolver_event = AppSyncResolverEvent(event)

        table_name = os.environ["apiKeyTableName"]
        id = resolver_event.arguments["id"]
        uid = resolver_event.identity.sub

        result = deleteApiKey(dynamodb_client, table_name, id, uid)

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
            return createError("Unexpected result", ErrorType.UNEXPECTED)

    except Exception as e:
        logger.error("ERROR %s", e)
        return createError("Unexpected error occured", ErrorType.UNEXPECTED)
