import os
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()


@logger.inject_lambda_context
def handler(event: dict, context: LambdaContext):
    logger.info("KMS ALIAS", os.environ["kmsApiKeyAliasName"])
