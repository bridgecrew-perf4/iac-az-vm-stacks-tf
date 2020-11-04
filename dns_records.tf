# create a DNS A record for all incoming "web.*" requests pointing to the loadbalancer
resource azurerm_dns_a_record web {
  name = "web"
  resource_group_name = var.resource_group_name
  zone_name = azurerm_dns_zone.solution.name
  ttl = 300
  target_resource_id = azurerm_public_ip.loadbalancer.id
  tags = merge(map("Name", "dnsr-${var.region_code}-${var.solution_name}-web"), local.module_common_tags)
}
