terraform {
  cloud {
    organization = "CONIX"

    workspaces {
      name = "Subnet-inspection"
    }
  }
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }

    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "2.21.1-6.6.ga"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

