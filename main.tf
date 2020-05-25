resource "aws_cloudwatch_event_rule" "trigger" {
  name                = var.name
  description         = "trigger"
  schedule_expression = var.cron
  is_enabled          = true
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.trigger.name
  target_id = var.name
  arn       = var.lambda.arn
  input     = "{}"
}

resource "aws_lambda_permission" "target_lambda_permission" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.trigger.arn
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name                = "${var.lambda.function_name}-error"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "120"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "${var.lambda.function_name} execution failed"
  insufficient_data_actions = []
  datapoints_to_alarm       = 1
  alarm_actions = [
    var.error_sns_topic_arn
  ]
  dimensions = {
    "FunctionName" = var.lambda.function_name
  }
  tags = var.tags
}

