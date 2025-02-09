import { util, extensions } from "@aws-appsync/utils";

export function request(_ctx) {
  return {};
}

export function response(ctx) {
  const userId = ctx.identity.sub;
  const filter = {
    userId: { eq: userId },
  };

  extensions.setSubscriptionFilter(util.transform.toSubscriptionFilter(filter));
  return null;
}
