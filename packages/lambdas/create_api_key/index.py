import os
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities.data_classes import AppSyncResolverEvent

logger = Logger()


def handler(event: dict, context: LambdaContext):
    kms_alias = os.environ["kmsApiKeyAliasName"]
    resolver_event = AppSyncResolverEvent(event)
    logger.info("RESOLVER_EVENT %s", resolver_event)
