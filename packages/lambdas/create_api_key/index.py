import os
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()


def handler(event: dict, context: LambdaContext):
    logger.info("EVENT %s CONTEXT %s", event, context)
    logger.info("KMS ALIAS %s", os.environ["kmsApiKeyAliasName"])
    variables = event["variables"]
    user_id = event["identity"]
    logger.info("VARIABLES %s USER_ID", variables, user_id)
