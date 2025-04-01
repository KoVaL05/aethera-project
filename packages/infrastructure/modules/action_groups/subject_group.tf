resource "aws_bedrockagent_agent_action_group" "routing_action_group" {
  action_group_name          = "routing-action-group"
  agent_id                   = var.subject_agent_id
  agent_version              = "DRAFT"
  skip_resource_in_use_check = true
  action_group_executor {
    lambda = var.subject_lambda_arn
  }
  function_schema {
    member_functions {
      functions {
        name = "take_route"
        parameters {
          map_block_key = "subject"
          type          = "string"
          description   = "Subject of the task to be called"
          required      = true
        }
        parameters {
          map_block_key = "task"
          type          = "string"
          description   = "Description of the action provided by user"
          required      = true
        }
      }
    }
  }
}
