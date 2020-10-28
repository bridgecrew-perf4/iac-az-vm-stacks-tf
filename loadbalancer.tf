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
}

# create a backend address pool for all web servers
resource azurerm_lb_backend_address_pool web {
  name = "lbbap-${var.region_code}-${var.solution_name}-web"
  resource_group_name = var.resource_group_name
  loadbalancer_id = azurerm_lb.loadbalancer.id
}