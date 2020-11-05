resource azurerm_application_gateway loadbalancer {
  name = "agw-${var.region_code}-${var.solution_name}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location

  tags = merge(map("Name", "agw-${var.region_code}-${var.solution_name}"), local.module_common_tags)

  backend_address_pool {
    name = "bap-${var.region_code}-${var.solution_name}"
  }

  backend_http_settings {
    name = "bhs-${var.region_code}-${var.solution_name}"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
  }

  frontend_ip_configuration {
    name = "agw-${var.region_code}-${var.solution_name}-feipc"
    public_ip_address_id = azurerm_public_ip.loadbalancer.id
  }

  frontend_port {
    name = "agw-${var.region_code}-${var.solution_name}-http"
    port = 80
  }

  frontend_port {
    name = "agw-${var.region_code}-${var.solution_name}-https"
    port = 443
  }

  gateway_ip_configuration {
    name = "agw-${var.region_code}-${var.solution_name}-gwipc"
    subnet_id = var.web_subnet_ids[0]
  }

  http_listener {
    name = "agw-${var.region_code}-${var.solution_name}-http"
    frontend_ip_configuration_name = "agw-${var.region_code}-${var.solution_name}-feipc"
    frontend_port_name = "agw-${var.region_code}-${var.solution_name}-http"
    protocol = "Http"
  }
/*
  http_listener {
    name = "agw-${var.region_code}-${var.solution_name}-https"
    frontend_ip_configuration_name = "agw-${var.region_code}-${var.solution_name}-feipc"
    frontend_port_name = "agw-${var.region_code}-${var.solution_name}-https"
    protocol = "Https"
    ssl_certificate_name = "agw-${var.region_code}-${var.solution_name}-ssl"
  }
*/
  request_routing_rule {
    name = "rrr-${var.region_code}-${var.solution_name}-http"
    http_listener_name = "agw-${var.region_code}-${var.solution_name}-http"
    rule_type = "Basic"
    backend_address_pool_name = "bap-${var.region_code}-${var.solution_name}"
    backend_http_settings_name = "bhs-${var.region_code}-${var.solution_name}"
  }
/*
  ssl_certificate {
    name = "agw-${var.region_code}-${var.solution_name}-ssl"
    key_vault_secret_id = azurerm_key_vault_certificate.ssl.id
  }
*/
  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    capacity = 2
  }
}

# create a public IP for the loadbalancer
resource azurerm_public_ip loadbalancer {
  name = "pip-${var.region_code}-${var.solution_name}-agw"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "web-${var.solution_name}"
  # reverse_fqdn = "web.${azurerm_dns_zone.solution.name}"
  tags = merge(map("Name", "pip-${var.region_code}-${var.solution_name}-agw"), local.module_common_tags)
}
