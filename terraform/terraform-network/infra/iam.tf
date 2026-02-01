############################################
# IAM POLICY – Allow reading RDS secret
############################################
resource "aws_iam_policy" "app_secrets_policy" {
  name        = "app-read-rds-secret-policy"
  description = "Allow EC2 instances to read RDS master credentials from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_db_instance.this.master_user_secret[0].secret_arn
      }
    ]
  })
}

############################################
# IAM ROLE – EC2 will assume this role
############################################
resource "aws_iam_role" "app_ec2_role" {
  name = "app-ec2-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

############################################
# ATTACH POLICY TO ROLE
############################################
resource "aws_iam_role_policy_attachment" "app_attach_secrets" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = aws_iam_policy.app_secrets_policy.arn
}

############################################
# INSTANCE PROFILE – Required for EC2/ASG
############################################
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "app-ec2-instance-profile"
  role = aws_iam_role.app_ec2_role.name
}
