## This Auto variables for Codebuid
dev_codebuild_project = {
  name          = "dev-Codebuild-project"
  description   = "CodeBuild project for the development environment"
  build_timeout = 30
  artifacts = {
    type = "NO_ARTIFACTS"
  }
  source = {
    type      = "GITHUB"
    location  = "https://github.com/mukesh0327/terraform-iac-devops-aws-codepipeline.git"
    buildspec = "buildspec-dev.yml"
  }
  environment = {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"
  }
}