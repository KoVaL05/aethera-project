from mypy_boto3_dynamodb.client import DynamoDBClient
from mypy_boto3_dynamodb.type_defs import (
    UpdateItemOutputTypeDef,
    PutItemOutputTypeDef,
    DeleteItemOutputTypeDef,
)
from aws_lambda_powertools import Logger
from .dynamodb_parser import python_to_dynamo

logger = Logger()


def putItem(
    dynamodb_client: DynamoDBClient, tableName: str, item: dict
) -> PutItemOutputTypeDef:
    logger.info()
    return dynamodb_client.put_item(TableName=tableName, Item=item)


def updateApiKey(
    dynamodb_client: DynamoDBClient,
    table_name: str,
    id: str,
    uid: str,
    value: bytes,
) -> UpdateItemOutputTypeDef:
    return dynamodb_client.update_item(
        TableName=table_name,
        Key=python_to_dynamo({"id": id}),
        UpdateExpression="SET #v = :new_value",
        ConditionExpression="#u = :user_id",
        ExpressionAttributeNames={"#v": "value", "#u": "userId"},
        ExpressionAttributeValues=python_to_dynamo(
            {":new_value": value, ":user_id": uid}
        ),
        ReturnValues="ALL_NEW",
    )


def deleteApiKey(
    dynamodb_client: DynamoDBClient, table_name: str, id: str, uid: str
) -> DeleteItemOutputTypeDef:
    return dynamodb_client.delete_item(
        TableName=table_name,
        Key=python_to_dynamo({"id": id}),
        ConditionExpression="#u = :user_id",
        ExpressionAttributeNames={"#u": "userId"},
        ExpressionAttributeValues=python_to_dynamo({":user_id": uid}),
        ReturnValues="ALL_OLD",
    )
