import boto3
import os
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.data_classes import (
    DynamoDBStreamEvent,
    event_source,
)
from aws_lambda_powertools.utilities.data_classes.dynamo_db_stream_event import (
    DynamoDBRecordEventName,
)
from mypy_boto3_appsync import AppSyncClient
from aws_lambda_powertools.utilities.typing import LambdaContext
from botocore.awsrequest import AWSRequest
from botocore.auth import SigV4Auth
from botocore.session import Session
from botocore.credentials import Credentials
import json
import requests

client: AppSyncClient = boto3.client("appsync")
logger = Logger()

query_templates = {
    DynamoDBRecordEventName.INSERT: """
        mutation notifyInsert($id: String!, $userId: String!, $keyType: String!, $createdAt: AWSTimestamp!) {
            notifyCreateApiKey(key: {id: $id, userId: $userId, keyType: $keyType, createdAt: $createdAt}) {
                createdAt
                id
                userId
                keyType
            }
        }
    """,
    DynamoDBRecordEventName.MODIFY: """
        mutation notifyModify($id: String!, $userId: String!, $keyType: String!, $createdAt: AWSTimestamp!) {
            notifyUpdateApiKey(key: {id: $id, userId: $userId, keyType: $keyType, createdAt: $createdAt}) {
                createdAt
                id
                userId
                keyType
            }
        }
    """,
    DynamoDBRecordEventName.REMOVE: """
        mutation notifyRemove($id: String!, $userId: String!, $keyType: String!, $createdAt: AWSTimestamp!) {
            notifyDeleteApiKey(key: {id: $id, userId: $userId, keyType: $keyType, createdAt: $createdAt}) {
                id
                userId
            }
        }
    """,
}


@event_source(data_class=DynamoDBStreamEvent)
@logger.inject_lambda_context
def handler(event: DynamoDBStreamEvent, context: LambdaContext):
    try:
        appsyncUrl = os.environ["apiKeyApiUrl"]
        session = Session()
        credentials = session.get_credentials().get_frozen_credentials()

        aws_credentials = Credentials(
            credentials.access_key, credentials.secret_key, credentials.token
        )

        logger.info(appsyncUrl)
        # translatedEvent = DynamoDBStreamEvent(event)
        # logger.info(translatedEvent)

        query = """mutation 
        notifyMutation($id: String!, $userId: String!, $keyType: String!, $createdAt: AWSTimestamp!) {
        notifyCreateApiKey(key: {id: $id, userId: $userId, keyType: $keyType, createdAt: $createdAt}) {
            createdAt
            id
            userId
            keyType
        }
        }"""
        for record in event.records:
            region = record.aws_region
            item = (
                record.dynamodb.old_image
                if DynamoDBRecordEventName.REMOVE == record.event_name
                else record.dynamodb.new_image
            )
            item.pop("value")
            logger.info(item)
            auth = SigV4Auth(aws_credentials, "appsync", region)
            match record.event_name:
                case DynamoDBRecordEventName.MODIFY:
                    pass
                case DynamoDBRecordEventName.INSERT:
                    aws_request = AWSRequest(
                        method="POST",
                        url=appsyncUrl,
                        headers={"Content-Type": "application/json"},
                        data=json.dumps(
                            {
                                "query": query_templates.get(record.event_name),
                                "variables": item,
                            }
                        ),
                    )
                    auth.add_auth(aws_request)
                    response = requests.post(
                        aws_request.url,
                        data=aws_request.data,
                        headers=dict(aws_request.headers),
                    )
                    logger.info(response)
                case DynamoDBRecordEventName.REMOVE:
                    pass
                case _:
                    pass
    except Exception as e:
        logger.error(e)
