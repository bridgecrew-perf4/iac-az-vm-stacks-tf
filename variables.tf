variable "region_name" {
  description = "The Azure region to deploy into."
}

variable "region_code" {
  description = "The code of Azure region to deploy into (supposed to be a meaningful abbreviation of region_name."
}

variable "organization_name" {
  description = "The name of the organization that owns all AWS resources."
}

variable "department_name" {
  description = "The name of the department that owns all AWS resources."
}

variable "project_name" {
  description = "The name of the project that owns all AWS resources."
}

variable "stage" {
  description = "The name of the current environment stage."
}

variable solution_name {
  description = "Name of the implemented solution"
}

variable resource_group_name {
  description = "The name of the resource group supposed to own all allocated resources; will create a new resource group if not specified"
  default = ""
}

variable resource_group_location {
  description = "The location of the resource group supposed to own all allocated resources"
  default = ""
}

variable vnet_name {
  description = "name of the VNet to use"
}

variable vnet_id {
  description = "unique identifier of the VNet to use"
}

variable "web_subnet_ids" {
  description = "unique identifiers of all subnets supposed to host web servers"
  type = list(string)
}

variable "web_vm_type" {
  description = "virtual machine type to be used for web servers"
  default = "Standard_B1s"
}

variable "web_image_id" {
  description = "unique identifier of the source image to be used for the web servers"
  default = ""
}

variable "min_web_servers" {
  description = "minimum number of web servers to be available at any time"
  type = number
}

variable "max_web_servers" {
  description = "maximum number of web servers to be available at any time"
  type = number
}

variable "app_subnet_ids" {
  description = "unique identifiers of all subnets supposed to host application servers"
  type = list(string)
}

variable "data_subnet_ids" {
  description = "unique identifiers of all subnets supposed to host database servers"
  type = list(string)
}

variable "application_gateway_subnet_id" {
  description = "unique identifier of the subnet supposed to application gateways"
}

