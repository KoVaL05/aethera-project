const { AppSyncClient } = require("@aws-sdk/client-appsync");
const { prepareRequestTest } = require("../common/utils.js");
const fs = require("fs");

const client = new AppSyncClient({ region: "eu-central-1" });
const testFilePath = __dirname + "/index.js";

test("validate request with valid arguments", async () => {
  const context = {
    info: {
      fieldName: "getField",
      parentTypeName: "Query",
      selectionSetList: ["field1", "field2"],
      selectionSetGraphQL: "{ field1 field2 }",
    },
    arguments: {
      arg1: "value1",
      arg2: "value2",
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

  expect(result.operation).toBe("Invoke");
  expect(result.payload.fieldName).toBe(context.info.fieldName);
  expect(result.payload.variables.arg1).toBe(context.arguments.arg1);
  expect(result.payload.variables.timestamp).toBeDefined();
});

test("validate request with missing identity", async () => {
  const context = {
    info: {
      fieldName: "getField",
      parentTypeName: "Query",
      selectionSetList: ["field1", "field2"],
      selectionSetGraphQL: "{ field1 field2 }",
    },
    arguments: {
      arg1: "value1",
      arg2: "value2",
    },
    identity: null,
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeDefined();
  expect(response.error.message).toContain("Unauthorized");
});

test("validate request with missing arguments", async () => {
  const context = {
    info: {
      fieldName: "getField",
      parentTypeName: "Query",
      selectionSetList: ["field1", "field2"],
      selectionSetGraphQL: "{ field1 field2 }",
    },
    arguments: {},
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

  expect(result.operation).toBe("Invoke");
  expect(result.payload.variables.timestamp).toBeDefined();
});

test("validate response with successful result", async () => {
  const context = {
    result: {
      key1: "value1",
      key2: "value2",
    },
    error: null,
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  expect(response.evaluationResult).toBeDefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result.key1).toBe(context.result.key1);
  expect(result.key2).toBe(context.result.key2);
});

test("validate response with error", async () => {
  const context = {
    result: null,
    error: {
      message: "Some error occurred",
      type: "ExecutionError",
    },
  };

  const command = prepareRequestTest(testFilePath, JSON.stringify(context));
  const response = await client.send(command);

  expect(response.error).toBeUndefined();
  const result = JSON.parse(response.evaluationResult);

  expect(result).toBeUndefined();
});
