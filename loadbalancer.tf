# create an external loadbalancer to route traffic to the web and application servers
resource azurerm_lb loadbalancer {
  name = "lbe-${var.region_code}-${var.solution_name}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  sku = "Standard"

  frontend_ip_configuration {
    name = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.loadbalancer.id
  }

  tags = merge(map("Name", "lbe-${var.region_code}-${var.solution_name}"), local.module_common_tags)
}

# create a public IP for the loadbalancer
resource azurerm_public_ip loadbalancer {
  name = "pip-${var.region_code}-${var.solution_name}-lbe"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "web-${var.solution_name}"
  # reverse_fqdn = "web.${azurerm_dns_zone.solution.name}"
  tags = merge(map("Name", "pip-${var.region_code}-${var.solution_name}-lbe"), local.module_common_tags)
}

# create a backend address pool for all web servers
resource azurerm_lb_backend_address_pool web {
  name = "lbbap-${var.region_code}-${var.solution_name}-web"
  resource_group_name = var.resource_group_name
  loadbalancer_id = azurerm_lb.loadbalancer.id
}

# create a loadbalancer probe which checks the health of the web servers
resource azurerm_lb_probe web {
  name = "lbp-${var.region_code}-${var.solution_name}-web"
  resource_group_name = var.resource_group_name
  loadbalancer_id = azurerm_lb.loadbalancer.id
  protocol = "Http"
  port = 80
  request_path = "/"
  interval_in_seconds = 15
  number_of_probes = 2
}

# create a loadbalancer rule for traffic to the web servers
resource azurerm_lb_rule web_http {
  resource_group_name = var.resource_group_name
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name = "lbr-${var.region_code}-${var.solution_name}-web-http"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
  probe_id = azurerm_lb_probe.web.id
  enable_tcp_reset = true
}
