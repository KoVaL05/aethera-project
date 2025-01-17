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
from aws_lambda_powertools.utilities.data_classes.appsync_resolver_event import (
    AppSyncIdentityCognito,
)
from mypy_boto3_dynamodb import DynamoDBClient
from mypy_boto3_kms import KMSClient

# Local application imports
from common.error_handlers_appsync import createError, ErrorType
from common.dynamodb_parser import dynamo_to_python
from common.dynamodb_handlers import updateApiKey
from common.kms_handlers import encrypt


logger = Logger()
kms_client: KMSClient = boto3.client("kms")
dynamodb_client: DynamoDBClient = boto3.client("dynamodb")


def handler(event: dict, context: LambdaContext):
    logger.info("TEST")
