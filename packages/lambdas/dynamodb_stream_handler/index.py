import boto3
import json
import os

from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest, AWSResponse
from botocore.httpsession import URLLib3Session
from botocore.session import get_session

from mypy_boto3_appsync import AppSyncClient
from appsync_queries import query_templates
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.data_classes import (
    DynamoDBStreamEvent,
    event_source,
)
from aws_lambda_powertools.utilities.data_classes.dynamo_db_stream_event import (
    DynamoDBRecordEventName,
)
from aws_lambda_powertools.utilities.typing import LambdaContext

client: AppSyncClient = boto3.client("appsync")
logger = Logger()



@event_source(data_class=DynamoDBStreamEvent)
@logger.inject_lambda_context
def handler(event: DynamoDBStreamEvent, context: LambdaContext):
    try:
        appsyncUrl = os.environ["apiKeyApiUrl"]
        session = get_session()
        credentials = session.get_credentials().get_frozen_credentials()
        logger.info(
            credentials.access_key,
            credentials.secret_key,
            credentials.token,
            credentials,
        )

        logger.info(appsyncUrl)
   
        for record in event.records:
            region = record.aws_region
            item = (
                record.dynamodb.old_image
                if DynamoDBRecordEventName.REMOVE == record.event_name
                else record.dynamodb.new_image
            )
            item["createdAt"] = int(item["createdAt"])
            item.pop("value")
            logger.info(item)
            auth = SigV4Auth(credentials, "appsync", region)
           
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
            response = URLLib3Session().send(aws_request.prepare())
            if isinstance(response, AWSResponse):
                logger.info(response.content)
            logger.info(response)
    except Exception as e:
        logger.error(e)
