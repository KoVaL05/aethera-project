const fs = require("fs");
const { EvaluateCodeCommand } = require("@aws-sdk/client-appsync");

const runtime = {
  name: "APPSYNC_JS",
  runtimeVersion: "1.0.0",
};

const prepareRequestTest = (path, context) => {
  const code = fs.readFileSync(path, { encoding: "utf8" });

  const params = {
    context,
    code,
    runtime,
    function: "request",
  };

  return new EvaluateCodeCommand(params);
};

const prepareResponseTest = (path, context) => {
  const code = fs.readFileSync(path, { encoding: "utf8" });

  const params = {
    context,
    code,
    runtime,
    function: "response",
  };

  return new EvaluateCodeCommand(params);
};

module.exports = { prepareRequestTest, prepareResponseTest };
