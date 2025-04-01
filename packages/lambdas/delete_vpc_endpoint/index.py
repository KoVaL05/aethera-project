import boto3
import os
from aws_lambda_powertools import Logger
from mypy_boto3_ec2.client import EC2Client

logger = Logger()
ec2: EC2Client = boto3.client('ec2')

def lambda_handler(event, context):
    vpc_id = os.environ.get('VPC_ID')
    
    response = ec2.describe_vpc_endpoints(Filters=[{'Name': 'vpc-id', 'Values': [vpc_id]}])
    
    for endpoint in response.get('VpcEndpoints', []):
        try:
            ec2.delete_vpc_endpoints(VpcEndpointIds=[endpoint['VpcEndpointId']])
        except Exception as e:
            logger.error(f"S3 vpc({endpoint['VpcEndpointId']}) endpoint delete error: {e}")

    
    return {
        'statusCode': 200,
        'body': "Deleted all VPC Endpoints"
    }
