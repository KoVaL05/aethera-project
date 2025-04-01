import { util } from "@aws-appsync/utils";

const isEmpty = (value) => {
  return (!value && value != false) || value == "";
};

export function request(ctx) {
  console.log("CONTEXT", ctx);
  if (isEmpty(ctx.identity?.issuer) || isEmpty(ctx.identity)) {
    return util.unauthorized();
  }

  const { id } = ctx.arguments;
  if (isEmpty(id)) {
    console.error(`EMPTY ID ${id}`);
    return util.error("EMPTY ID", "BadRequest");
  }

  return {
    operation: "DeleteItem",
    key: { id: util.dynamodb.toDynamoDB(id) },
    condition: {
      expression: "userId = :userId",
      expressionValues: util.dynamodb.toMapValues({
        ":userId": ctx.identity.sub,
      }),
    },
  };
}

export function response(ctx) {
  const { result, error } = ctx;
  const finalError = error ?? result.error;
  if (finalError) {
    util.error(finalError.message, finalError.type, result);
  }
  return result;
}
