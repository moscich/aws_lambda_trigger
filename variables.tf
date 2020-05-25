variable "lambda" {
        type = object({
          arn = string
          function_name = string
        })
}

variable "cron" {
        type = string
}

variable "name" {
        type = string
}

variable "error_sns_topic_arn" {
        type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

