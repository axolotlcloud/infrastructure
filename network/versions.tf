terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://482fcd4ffcc13c19aa1b7c1c7a9efc21.r2.cloudflarestorage.com"
    }
    region = "auto"
    bucket = "axolotl-infra-tf"
    key = "network/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}
