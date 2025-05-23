import 'package:flutter_dotenv/flutter_dotenv.dart';

final amplifyConfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "${dotenv.env["USER_POOL_ID"]}",
            "AppClientId": "${dotenv.env["CLIENT_POOL_ID"]}",
            "Region": "eu-central-1"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "signupAttributes": ["EMAIL"],
            "autoVerifiedAttributes": ["EMAIL"],
            "passwordProtectionSettings": {
                "passwordPolicyMinLength": 8,
                "passwordPolicyCharacters": []
            },
            "OAuth": {
              "WebDomain": "https://test-3d4u1ltw.auth.eu-central-1.amazoncognito.com",
              "AppClientId": "${dotenv.env["CLIENT_POOL_ID"]}",
              "SignInRedirectURI": "aethera://",
              "SignOutRedirectURI": "aethera://",
              "Scopes": ["openid", "email", "profile"],
              "ResponseType":"token"
            }
          }
        }
      }
    }
  }
}''';
