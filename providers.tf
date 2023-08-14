
#PROVIDERS

provider "aws" {
  region = var.region
}


terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"

    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.5.0"
    }
  }
}

# terraform {
#   required_providers {
#     random = {
#       source  = "hashicorp/random"
#       version = "~>3.0"
#     }
#   }
# }
