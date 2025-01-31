terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
      }
    }

    backend "s3"{
        bucket = "terraformbackendtesting"
        key = "terraform/terraform"
        region = "us-east-1"
    }
}