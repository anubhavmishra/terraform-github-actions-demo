terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mishra-tf-cloud-demo"

    workspaces {
      name = "terraform-github-actions-github-satellite-demo"
    }
  }
}