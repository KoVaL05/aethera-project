import boto3
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.data_classes import DynamoDBStreamEvent
from mypy_boto3_appsync import AppSyncClient
from aws_lambda_powertools.utilities.typing import LambdaContext

client: AppSyncClient = boto3.client("appsync")
logger = Logger()


@logger.inject_lambda_context
def handler(event: DynamoDBStreamEvent, context: LambdaContext):
    for record in event.records:
        match record.event_name:
            case "INSERT":
                pass
            case "MODIFY":
                pass
            case "REMOVE":

                pass
            case _:
                pass


import json
import os
import requests
import boto3
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest

# Environment variables (Set in AWS Lambda)
APPSYNC_URL = os.getenv(
    "APPSYNC_URL"
)  # Example: "https://your-api-id.appsync-api.us-east-1.amazonaws.com/graphql"
AWS_REGION = "us-east-1"  # Change to your region


def sign_request(url, query, region):
    """Sign the request using IAM SigV4"""
    session = boto3.session.Session()
    credentials = session.get_credentials()
    frozen_creds = credentials.get_frozen_credentials()

    # Create an AWS request
    request = AWSRequest(
        method="POST",
        url=url,
        data=json.dumps(query),
        headers={"Content-Type": "application/json"},
    )
    SigV4Auth(frozen_creds, "appsync", region).add_auth(request)

    return request


def lambda_handler(event, context):
    # Define your GraphQL query
    query = """
    query GetItem($id: ID!) {
      getItem(id: $id) {
        id
        name
        description
      }
    }
    """

    # Define variables
    variables = {"id": "123"}

    # Construct payload
    payload = {"query": query, "variables": variables}

    # Sign the request using IAM SigV4
    signed_request = sign_request(APPSYNC_URL, payload, AWS_REGION)

    # Send the signed request to AppSync
    response = requests.post(
        APPSYNC_URL, data=json.dumps(payload), headers=dict(signed_request.headers)
    )

    # Return the response
    return response.json()
