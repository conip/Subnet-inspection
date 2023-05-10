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
      version = "~>3.15.1"
    }

    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "2.21.1-6.6.ga"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0.0"
    }

    # test with local added here
  }
}

