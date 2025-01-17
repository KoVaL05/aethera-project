const { AppSyncClient } = require("@aws-sdk/client-appsync");
const { prepareRequestTest } = require("../common/utils.js");
const fs = require("fs");

const client = new AppSyncClient({ region: "eu-central-1" });
const testFilePath = __dirname + "/index.js";

test("validate request with valid arguments", async () => {
  const context = {
    arguments: {
      limit: 10,
      nextToken: null,
    },
    identity: {
      sub: "user123",
      issuer: "cognito",
      username: "TestUser",
      claims: {},
      sourceIp: ["x.x.x.x"],
      defaultAuthStrategy: "ALLOW",
    },
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  expect(response.evaluationResult).toBeDefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result.index).toBe("UIDIndex");
  expect(result.limit).toBe(context.arguments.limit);
  expect(result.query.userId.eq).toBe(context.identity.sub);
});

test("validate request with missing identity", async () => {
  const context = {
    arguments: {
      limit: 10,
      nextToken: null,
    },
    identity: null,
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeDefined();
  expect(response.error.message).toContain("Unauthorized");
});

test("validate request with missing limit argument", async () => {
  const context = {
    arguments: {
      nextToken: null,
    },
    identity: {
      sub: "user123",
      issuer: "cognito",
      username: "TestUser",
      claims: {},
      sourceIp: ["x.x.x.x"],
      defaultAuthStrategy: "ALLOW",
    },
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result.index).toBe("UIDIndex");
  expect(result.limit).toBeUndefined();
  expect(result.query.userId.eq).toBe(context.identity.sub);
});

test("validate response with successful query", async () => {
  const context = {
    error: null,
    result: {
      items: [
        { id: "item1", name: "Item 1" },
        { id: "item2", name: "Item 2" },
      ],
    },
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  expect(response.evaluationResult).toBeDefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result).toHaveLength(2);
  expect(result[0].id).toBe("item1");
  expect(result[1].id).toBe("item2");
});

test("validate response with error", async () => {
  const context = {
    error: {
      message: "Some error occurred",
      type: "DynamoDBError",
    },
    result: null,
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  expect(response.evaluationResult).toBeDefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result.errors).toHaveLength(1);
  expect(result.errors[0].message).toBe(context.error.message);
  expect(result.errors[0].type).toBe(context.error.type);
});
