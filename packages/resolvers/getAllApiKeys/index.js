import { util } from "@aws-appsync/utils";
import { query } from "@aws-appsync/utils/dynamodb";

export function request(ctx) {
  const { limit, nextToken } = ctx.args;

  return query({
    index: "UIDIndex",
    limit,
    nextToken,
    query: {
      userId: { eq: ctx.identity.sub },
    },
  });
}

export function response(ctx) {
  const { error, result } = ctx;
  if (error) {
    return util.appendError(error.message, error.type, result);
  }

  return result.items ?? [];
}
