## This Auto variables for Codebuid
stag_codebuild_project = {
  name          = "stag-Codebuild-project"
  description   = "CodeBuild project for the stagelopment environment"
  build_timeout = 30
  artifacts = {
    type = "NO_ARTIFACTS"
  }
  source = {
    type      = "GITHUB"
    location  = "https://github.com/mukesh0327/terraform-iac-stagops-aws-codepipeline.git"
    buildspec = "buildspec-stag.yml"
  }
  environment = {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"
  }
}

