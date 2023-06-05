# =====================================================================================================================
# Antes de executar a pipeline, executar o código para a criação da VPC,
# Caso contrário não funcionará a execução da pipeline.
# A chave .pub deve estar dentro da maquina e o acesso deve ser feito com a key aws-key e/ou azure.key
#
# ------------------------ Corrigir ------------------------------------------------------------------------------------
# 03.06.23 - Testado e validado o código, porém ao rodar via pipeline apresenta erro (verificar par de chaves no azure devops)
# =======================================================================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "remote-state"
    storage_account_name = "edevopsremotestate"
    container_name       = "remote-state"
    key                  = "pipeline-github-actions/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "remote-state"
    storage_account_name = "edevopsremotestate"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }
}

provider "aws" {
  region = "sa-east-1"
  default_tags {
    tags = {
      owner      = "edevops"
      managed-by = "terraform"
    }
  }
}
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "edwanderson-remote-state-aws-az"
    key    = "aws-vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}