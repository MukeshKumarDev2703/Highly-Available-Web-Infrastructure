variable "codepipeline" {
  type = object({
    name = string
    stage = map(object({
      name = string
      action = map(object({
        name             = string
        category         = string
        owner            = string
        provider         = string
        version          = number
        configuration    = map(string)
        input_artifacts  = optional(list(string), [])
        output_artifacts = optional(list(string), [])
      }))
    }))
  })
}