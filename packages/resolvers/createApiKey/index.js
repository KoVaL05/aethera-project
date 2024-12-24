import { util } from "@aws-appsync/utils";

export function request(ctx) {
  return {
    operation: "Invoke",
    payload: {
      fieldName: ctx.info.fieldName,
      parentTypeName: ctx.info.parentTypeName,
      variables: ctx.info.variables,
      selectionSetList: ctx.info.selectionSetList,
      selectionSetGraphQL: ctx.info.selectionSetGraphQL,
    },
  };
}

export function response(ctx) {
  const { result, error } = ctx;
  if (error) {
    util.error(error.message, error.type, result);
  }
  return result;
}
