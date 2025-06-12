import { util } from "@aws-appsync/utils";

const isEmpty = (value) => {
  return (!value && value != false) || value == "";
};

export function request(ctx) {
  console.log("CONTEXT", ctx);
  if (isEmpty(ctx.identity?.issuer) || isEmpty(ctx.identity)) {
    return util.unauthorized();
  }

  const { type, value } = ctx.arguments;
  if (isEmpty(type) || isEmpty(value)) {
    console.error(`EMPTY TYPE OR VALUE TEST ${type} ${value}`);
    return util.error("EMPTY VALUE OR TYPE", "BadRequest");
  }

  return {
    operation: "Invoke",
    payload: {
      ...ctx,
      arguments: { ...ctx.arguments, timestamp: util.time.nowEpochSeconds() },
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
