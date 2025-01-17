from mypy_boto3_dynamodb.client import DynamoDBClient
from mypy_boto3_dynamodb.type_defs import UpdateItemOutputTypeDef
from aws_lambda_powertools import Logger
from dynamodb_parser import python_to_dynamo
from mypy_boto3_dynamodb.type_defs import PutItemOutputTypeDef

logger = Logger()


def putItem(
    dynamodb_client: DynamoDBClient, tableName: str, item: dict
) -> PutItemOutputTypeDef:
    return dynamodb_client.put_item(TableName=tableName, Item=item)


def updateApiKey(
    dynamodb_client: DynamoDBClient,
    tableName: str,
    id: str,
    uid: str,
    value: bytes,
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
