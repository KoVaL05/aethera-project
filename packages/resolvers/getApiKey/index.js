import { util } from "@aws-appsync/utils";
import { get } from "@aws-appsync/utils/dynamodb";

export function request(ctx) {
  const { id } = ctx.args;
  const key = { id };
  return get({
    key,
  });
}

export function response(ctx) {
  const { error, result } = ctx;
  if (error) {
    return util.appendError(error.message, error.type, result);
  }
  if (result.userId !== ctx.identity.sub) {
    return util.unauthorized();
  }
  return result;
}
