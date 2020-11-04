# get parent DNS zone managing global domain
data azurerm_dns_zone parent {
  name = "azure.msgoat.eu"
}

# create a dedicated DNS zone to manage all DNS records of this solution
resource azurerm_dns_zone solution {
  name = "${var.solution_name}.azure.msgoat.eu"
  resource_group_name = var.resource_group_name
  tags = merge(map("Name", "dnsz-${var.region_code}-${var.solution_name}"), local.module_common_tags)
}

# add a DNS NS record with the solution nameserver to the parent DNS zone
resource azurerm_dns_ns_record child {
  name = var.solution_name
  resource_group_name = data.azurerm_dns_zone.parent.resource_group_name
  zone_name = data.azurerm_dns_zone.parent.name
  records = azurerm_dns_zone.solution.name_servers
  ttl = 86700
  tags = merge(map("Name", "dnsr-${var.region_code}-${var.solution_name}"), local.module_common_tags)
}