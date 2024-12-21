const { AppSyncClient } = require("@aws-sdk/client-appsync");
const { prepareRequestTest } = require("../common/utils.js");
const fs = require("fs");

const client = new AppSyncClient({ region: "eu-central-1" });
const testFilePath = __dirname + "/index.js";

test("validate query accounts request", async () => {
  const context = {
    arguments: {
      id: "api_key_id",
    },
    identity: {
      sub: "1234",
      issuer: "cognito",
      username: "Test",
      claims: {},
      sourceIp: ["x.x.x.x"],
      defaultAuthStrategy: "ALLOW",
    },
    result: {
      id: "api_key_id",
      userId: "1234",
      keyType: "graphql",
      createdAt: 123456789,
    },
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));

  const response = await client.send(command);
  expect(response.error).toBeUndefined();
  expect(response.evaluationResult).toBeDefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result.operation).toBe("GetItem");
  expect(result.key.id.S).toBe(context.arguments.id);
});

test("validate query accounts request - missing id argument", async () => {
  const context = {
    arguments: {},
    identity: {
      sub: "1234",
      issuer: "cognito",
      username: "Test",
      claims: {},
      sourceIp: ["x.x.x.x"],
      defaultAuthStrategy: "ALLOW",
    },
    result: null,
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));

  const response = await client.send(command);

  expect(response.error).toBeDefined();
  expect(response.error.message).toContain("Missing required argument: id");
});

test("validate query accounts request - unauthorized access", async () => {
  const context = {
    arguments: {
      id: "api_key_id",
    },
    identity: null,
    result: null,
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));

  const response = await client.send(command);

  expect(response.error).toBeDefined();
  expect(response.error.message).toContain("Unauthorized");
});

test("validate query accounts request - extra fields in context", async () => {
  const context = {
    arguments: {
      id: "api_key_id",
    },
    identity: {
      sub: "1234",
      issuer: "cognito",
      username: "Test",
      claims: {},
      sourceIp: ["x.x.x.x"],
      defaultAuthStrategy: "ALLOW",
    },
    result: {
      id: "api_key_id",
      userId: "1234",
      keyType: "graphql",
      createdAt: 123456789,
    },
    extraField: "irrelevant data",
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));

  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  const result = JSON.parse(response.evaluationResult);
  expect(result.operation).toBe("GetItem");
  expect(result.key.id.S).toBe(context.arguments.id);
});
