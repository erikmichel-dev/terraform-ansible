terraform {
  cloud {
    organization = "em-terraform-ansible"

    workspaces {
      name = "terraform-ansible"
    }
  }
}