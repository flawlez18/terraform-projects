#LOCALS
resource "random_integer" "rand" {
  min = 10000
  max = 99999
  # keepers = {
  #   # Generate a new integer each time we switch to a new listener ARN
  #   listener_arn = var.listener_arn
  #}

}

locals {
  common_tags = {
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code



  }

  s3_bucket_name = "globo-web-app-${random_integer.rand.result}"

}
