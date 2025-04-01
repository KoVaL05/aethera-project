import boto3
import os
import json
from mypy_boto3_ec2.client import EC2Client

ec2: EC2Client = boto3.client('ec2')

def lambda_handler(event, context):
    vpc_id = os.environ.get('VPC_ID')
    sg_id = os.environ.get('SECURITY_GROUP_ID')
    subnet_ids = json.loads(os.environ.get('SUBNET_IDS'))

    current_region = os.environ.get('currentRegion')

    existing_endpoints = ec2.describe_vpc_endpoints(
        Filters=[
            {
                'Name': 'vpc-id',
                'Values': [vpc_id]
            },
            {
                'Name': 'service-name',
                'Values': [f'com.amazonaws.{current_region}.appsync-api']
            }
        ]
    )

    if existing_endpoints['VpcEndpoints']:
        existing_endpoint_id = existing_endpoints['VpcEndpoints'][0]['VpcEndpointId']
        return {
            'statusCode': 200,
            'body': f"S3 VPC Endpoint already exists: {existing_endpoint_id}"
        }

    response = ec2.create_vpc_endpoint(
        VpcId=vpc_id,
        ServiceName=f'com.amazonaws.{current_region}.appsync-api',
        VpcEndpointType='Interface',
        SecurityGroupIds=[sg_id],
        SubnetIds=subnet_ids,
        PrivateDnsEnabled=True
    )
    
    return {
        'statusCode': 200,
        'body': f"Created new VPC Endpoint: {response['VpcEndpoint']['VpcEndpointId']}"
    }
# resource "aws_vpc_endpoint" "appsync" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = format("com.amazonaws.%s.appsync-api",data.aws_region.current.name)
#   vpc_endpoint_type = "Interface"
  
#   subnet_ids          = [aws_subnet.private_appsync_subnet_a.id,aws_subnet.private_appsync_subnet_b.id,aws_subnet.private_appsync_subnet_c.id]
#   security_group_ids  = [aws_security_group.appsync_endpoint.id]
  
#   private_dns_enabled = true
# }
