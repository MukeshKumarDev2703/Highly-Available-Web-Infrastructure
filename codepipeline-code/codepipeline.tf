resource "aws_codepipeline" "name" {
  #depends_on = [aws_s3_bucket.codepipeline_artifact]
  name       = var.codepipeline.name
  role_arn   = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact.bucket
    type     = "S3"
  }

  #   stage {
  #     name = "Source"
  #     action {
  #       name     = "Source"
  #       category = "Source"
  #       owner    = "AWS"
  #       provider = "CodeStarSourceConnection"
  #       version  = "1"
  #       configuration = {
  #         FullRepositoryId = "mukesh0327/terraform-iac-devops-aws-codepipeline"
  #         BranchName       = "main"
  #         ConnectionArn    = aws_codestarconnections_connection.connections.arn
  #       }
  #       output_artifacts = ["source_output"]

  #     }

  #   }

  #   stage {
  #     name = "Build"
  #     action {
  #       name             = "Build"
  #       category         = "Build"
  #       owner            = "AWS"
  #       provider         = "CodeBuild"
  #       input_artifacts  = ["source_output"]
  #       output_artifacts = ["build_output"]
  #       version          = "1"
  #       configuration = {
  #         ProjectName = aws_codebuild_project.dev_project.name
  #       }

  #     }
  #   }
  #   stage {
  #     name = "Approval"
  #     action {
  #       name     = "EmailApproval"
  #       category = "Approval"
  #       owner    = "AWS"
  #       provider = "Manual"
  #       version  = "1"
  #       configuration = {
  #         NotificationArn = aws_sns_topic.approval_notifications.arn
  #       }
  #     }
  #   }
  #   stage {
  #     name = "Deploy"
  #     action {
  #       name            = "DeployAction"
  #       category        = "Build"
  #       owner           = "AWS"
  #       provider        = "CodeBuild"
  #       input_artifacts = ["source_output"]
  #       version         = "1"
  #       configuration = {
  #         ProjectName = aws_codebuild_project.staging_project.name
  #       }
  #     }
  #   }
  # }


  dynamic "stage" {
    for_each = var.codepipeline.stage
    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.action
        content {
          name          = action.value.name
          category      = action.value.category
          owner         = action.value.owner
          provider      = action.value.provider
          version       = action.value.version
          # Add configuration only if applicable
          configuration = action.value.provider == "CodeStarSourceConnection" ? {
            FullRepositoryId = action.value.configuration["FullRepositoryId"]
            BranchName       = action.value.configuration["BranchName"]
            ConnectionArn    = aws_codestarconnections_connection.connections.arn
          } : action.value.provider == "CodeBuild" ? {
            ProjectName = stage.value.name == "Build" ? aws_codebuild_project.dev_project.name : aws_codebuild_project.staging_project.name
          } : action.value.provider == "Manual" ? {
            NotificationArn = aws_sns_topic.approval_notifications.arn
          } : action.value.configuration

          output_artifacts = action.value.output_artifacts
          input_artifacts  = action.value.input_artifacts
        }
      }
    }

  }
}