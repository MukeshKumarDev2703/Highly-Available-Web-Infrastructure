codepipeline = {
  name = "devops-cicd-pipeline"
  stage = {
    Stage1 = {
      name = "Source"
      action = {
        Action1 = {
          name     = "SourceAction"
          category = "Source"
          owner    = "AWS"
          provider = "CodeStarSourceConnection"
          version  = 1
          configuration = {
            FullRepositoryId = "mukesh0327/terraform-iac-devops-aws-codepipeline"
            BranchName       = "main"
            #ConnectionArn    = aws_codestarconnections_connection.connections.arn
          }
          output_artifacts = ["source_output"]
        }
      }
    },
    Stage2 = {
      name = "Build"
      action = {
        Action1 = {
          name     = "BuildAction"
          category = "Build"
          owner    = "AWS"
          provider = "CodeBuild"
          version  = 1
          configuration = {
            #ProjectName = aws_codebuild_project.dev_project.name
          }
          input_artifacts  = ["source_output"]
          output_artifacts = ["build_output"]

        }
      }
    },
    Stage3 = {
      name = "Approval"
      action = {
        Action1 = {
          name     = "EmailApproval"
          category = "Approval"
          owner    = "AWS"
          provider = "Manual"
          version  = 1
          configuration = {
            #NotificationArn = aws_sns_topic.approval_notifications.arn
          }
        }
      }
    },
    Stage4 = {
      name = "Deploy"
      action = {
        Action1 = {
          name     = "DeployAction"
          category = "Build"
          owner    = "AWS"
          provider = "CodeBuild"
          version  = 1
          configuration = {
            #ProjectName = aws_codebuild_project.staging_project.name
          }
          input_artifacts = ["source_output"]

        }
      }
    }

  }
}