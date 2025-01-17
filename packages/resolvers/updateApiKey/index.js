import { util } from "@aws-appsync/utils";

const isEmpty = (value) => {
  return (!value && value != false) || value == "";
};

export function request(ctx) {
  console.log("CONTEXT", ctx);
  if (isEmpty(ctx.identity?.issuer) || isEmpty(ctx.identity)) {
    return util.unauthorized();
  }

  const { id, value } = ctx.arguments;
  if (isEmpty(id) || isEmpty(value)) {
    console.error(`EMPTY ID OR VALUE ${id} ${value}`);
    return util.error("EMPTY VALUE OR ID", "BadRequest");
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
