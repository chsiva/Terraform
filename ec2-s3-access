# access s3, ec2, SSM

resource "aws_iam_role" "example" {
  name                = "test_role_to_access_multiple_services"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json # Policy on line 11, 26, 41 that grants an entity permission to assume the role.
}

resource "aws_iam_policy" "policy_one" {
  name = "policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:Describe*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "policy_two" {
  name = "policy-381966"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:List*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "policy_three" {
  name = "policy-381966"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssm:Describe*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
