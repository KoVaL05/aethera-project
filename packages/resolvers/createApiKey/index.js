import { util } from "@aws-appsync/utils";

export function request(ctx) {
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
