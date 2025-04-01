import { util } from "@aws-appsync/utils";
import { query } from "@aws-appsync/utils/dynamodb";

export function request(ctx) {
  const { limit, nextToken, userId } = ctx.args;

  const effectiveUserId = userId || ctx.identity.sub;

  return query({
    index: "UIDIndex",
    limit,
    nextToken,
    query: {
      userId: { eq: effectiveUserId },
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
