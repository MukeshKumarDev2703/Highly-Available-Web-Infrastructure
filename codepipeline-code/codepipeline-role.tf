resource "aws_iam_role" "codepipeline_role" {
  name = "devops-codepipeline-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "devops-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "iam:PassRole",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "codestar-connections:GetConnection",
          "codestar-connections:UseConnection",
          "codestar-connections:PassConnection",
        ]
        Resource = [
          aws_codestarconnections_connection.connections.arn,
          // Add more ARNs as needed for other connections
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codepipeline:StartPipelineExecution",
          "codepipeline:GetPipelineExecution",
          "codepipeline:GetPipeline",
          "codepipeline:ListPipelines",
          "codepipeline:ListPipelineExecutions",
          "codepipeline:PollForJobs",
          "codepipeline:AcknowledgeJob",
          "codepipeline:GetJobDetails",
          "codepipeline:PutApprovalResult", // Required for manual approvals
        ],
        Resource = "*",
      },
      {

        Effect : "Allow",
        Action : [
          "sns:DeleteTopic",
          "sns:ListTopics",
          "sns:Unsubscribe",
          "sns:CreatePlatformEndpoint",
          "sns:OptInPhoneNumber",
          "sns:CheckIfPhoneNumberIsOptedOut",
          "sns:GetDataProtectionPolicy",
          "sns:ListEndpointsByPlatformApplication",
          "sns:SetEndpointAttributes",
          "sns:Publish",
          "sns:DeletePlatformApplication",
          "sns:SetPlatformApplicationAttributes",
          "sns:VerifySMSSandboxPhoneNumber",
          "sns:Subscribe",
          "sns:ConfirmSubscription",
          "sns:ListTagsForResource",
          "sns:DeleteSMSSandboxPhoneNumber",
          "sns:PutDataProtectionPolicy",
          "sns:ListSubscriptionsByTopic",
          "sns:GetTopicAttributes",
          "sns:ListSMSSandboxPhoneNumbers",
          "sns:CreatePlatformApplication",
          "sns:SetSMSAttributes",
          "sns:CreateTopic",
          "sns:GetPlatformApplicationAttributes",
          "sns:GetSubscriptionAttributes",
          "sns:ListSubscriptions",
          "sns:ListOriginationNumbers",
          "sns:DeleteEndpoint",
          "sns:ListPhoneNumbersOptedOut",
          "sns:GetEndpointAttributes",
          "sns:SetSubscriptionAttributes",
          "sns:GetSMSSandboxAccountStatus",
          "sns:CreateSMSSandboxPhoneNumber",
          "sns:ListPlatformApplications",
          "sns:GetSMSAttributes"
        ],
        "Resource" : "*"
      }
    ]
  })
}
