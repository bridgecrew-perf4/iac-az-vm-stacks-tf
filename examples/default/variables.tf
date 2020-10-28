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

variable network_name {
  description = "name of the reference network to create"
}

variable network_cidr {
  description = "CIDR block of the network"
}