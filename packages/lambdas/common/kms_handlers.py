from aws_lambda_powertools import Logger
from mypy_boto3_kms import KMSClient

logger = Logger()


def encrypt(kms_alias: str, data: str, kms_client: KMSClient) -> bytes:
    response = kms_client.encrypt(KeyId=kms_alias, Plaintext=data.encode())
    logger.info(
        f"The string was encrypted with algorithm {response['EncryptionAlgorithm']}"
    )
    return response["CiphertextBlob"]
