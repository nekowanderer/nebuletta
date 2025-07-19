# IAM Role for VPC Flow Logs
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "flow_log" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "flow_log_role" {
  name               = "${local.prefix}-flow-log-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-flow-log-role" })
}

resource "aws_iam_role_policy" "flow_log_policy" {
  name   = "${local.prefix}-flow-log-policy"
  role   = aws_iam_role.flow_log_role.id
  policy = data.aws_iam_policy_document.flow_log.json
}
