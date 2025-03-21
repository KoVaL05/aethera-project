from aws_lambda_powertools.utilities.data_classes.dynamo_db_stream_event import (
    DynamoDBRecordEventName,
)

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
