import boto3
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.data_classes import DynamoDBStreamEvent
from mypy_boto3_appsync import AppSyncClient
from aws_lambda_powertools.utilities.typing import LambdaContext

client: AppSyncClient = boto3.client("appsync")
logger = Logger()


@logger.inject_lambda_context
def handler(event: dict, context: LambdaContext):
    logger.info(event)
