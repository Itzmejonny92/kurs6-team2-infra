terraform {
  backend "gcs" {
    bucket = "team2-tfstate-dd541fba"
    prefix = "terraform/state"
  }
}
