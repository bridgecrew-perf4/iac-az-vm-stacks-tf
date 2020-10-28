
output "vnet_id" {
  description = "Unique identifier of the newly created VNet."
  value = module.reference_vnet.vnet_id
}

output "vnet_name" {
  description = "Fully qualified name of the newly created VNet."
  value = module.reference_vnet.vnet_name
}

output "public_subnet_ids" {
  description = "Unique identifiers of all public subnets"
  value = module.reference_vnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Unique identifiers of all private subnets"
  value = module.reference_vnet.private_subnet_ids
}

output "web_subnet_ids" {
  description = "Unique identifiers of all web subnets"
  value =  module.reference_vnet.web_subnet_ids
}

output "app_subnet_ids" {
  description = "Unique identifiers of all application subnets"
  value = module.reference_vnet.app_subnet_ids
}

output "data_subnet_ids" {
  description = "Unique identifiers of all datastore subnets"
  value = module.reference_vnet.data_subnet_ids
}

output "resource_group_name" {
  description = "Name of the resource group hosting all network components"
  value = module.reference_vnet.resource_group_name
}