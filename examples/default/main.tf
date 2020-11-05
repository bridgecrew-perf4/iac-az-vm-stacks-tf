# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.20"
  features {}
}

locals {
  main_common_tags = {
    Organization = var.organization_name
    Department = var.department_name
    Project = var.project_name
    Stage = var.stage
  }
}

# Create a new resource group if no resource group was specified
resource azurerm_resource_group owner {
  name = "rg-${var.region_code}-${var.solution_name}-solution"
  location = var.region_name
  tags = merge(map("Name", "rg-${var.region_code}-${var.solution_name}-solution"), local.main_common_tags)
}

module reference_vnet {
  source = "../../../iac-az-reference-vnet-tf"
  region_name = var.region_name
  region_code = var.region_code
  organization_name = var.organization_name
  department_name = var.department_name
  project_name = var.project_name
  stage = var.stage
  resource_group_name = azurerm_resource_group.owner.name
  resource_group_location = azurerm_resource_group.owner.location
  network_name = var.solution_name
  network_cidr = var.network_cidr
  bastions_enabled = false
  network_security_groups_enabled = false
}

module vm_stacks {
  source = "../.."
  region_name = var.region_name
  region_code = var.region_code
  organization_name = var.organization_name
  department_name = var.department_name
  project_name = var.project_name
  stage = var.stage
  solution_name = var.solution_name
  resource_group_name = azurerm_resource_group.owner.name
  resource_group_location = azurerm_resource_group.owner.location
  vnet_name = module.reference_vnet.vnet_name
  vnet_id = module.reference_vnet.vnet_id
  web_subnet_ids = module.reference_vnet.web_subnet_ids
  app_subnet_ids = module.reference_vnet.app_subnet_ids
  data_subnet_ids = module.reference_vnet.data_subnet_ids
  min_web_servers = 3
  max_web_servers = 3
}