resource "aws_codebuild_project" "dev_project" {
  name          = var.dev_codebuild_project.name
  description   = var.dev_codebuild_project.description
  build_timeout = var.dev_codebuild_project.build_timeout

  artifacts {
    type = var.dev_codebuild_project.artifacts.type
  }


  source {
    type      = var.dev_codebuild_project.source.type
    location  = var.dev_codebuild_project.source.location
    buildspec = var.dev_codebuild_project.source.buildspec
  }

  environment {
    compute_type = var.dev_codebuild_project.environment.compute_type
    image        = var.dev_codebuild_project.environment.image
    type         = var.dev_codebuild_project.environment.type
  }

  service_role = aws_iam_role.codebuild_role.arn
}

resource "aws_codebuild_project" "staging_project" {
  name          = var.stag_codebuild_project.name
  description   = var.stag_codebuild_project.description
  build_timeout = var.stag_codebuild_project.build_timeout

  artifacts {
    type = var.stag_codebuild_project.artifacts.type
  }


  source {
    type      = var.stag_codebuild_project.source.type
    location  = var.stag_codebuild_project.source.location
    buildspec = var.stag_codebuild_project.source.buildspec
  }

  environment {
    compute_type = var.stag_codebuild_project.environment.compute_type
    image        = var.stag_codebuild_project.environment.image
    type         = var.stag_codebuild_project.environment.type
  }

  service_role = aws_iam_role.codebuild_role.arn
}