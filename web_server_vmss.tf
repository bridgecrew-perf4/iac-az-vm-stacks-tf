resource azurerm_linux_virtual_machine_scale_set web {
  name = "vmss-${var.region_code}-${var.solution_name}-web"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  sku = var.web_vm_type
  instances = var.min_web_servers
  admin_username   = "adminuser"
  zone_balance = true
  zones = ["1", "2", "3"]
  single_placement_group = true
  custom_data = filebase64("${path.module}/resources/web-cloud-init.sh")
  upgrade_mode = "Automatic"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./resources/cxp-az-demo.pub")
  }

  network_interface {
    name = "nic-${var.region_code}-${var.solution_name}-web"
    ip_configuration {
      name = "ipc-${var.region_code}-${var.solution_name}-web"
      subnet_id = var.web_subnet_ids[0]
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.loadbalancer.backend_address_pool[0].id]
      primary = true
    }
    primary = true
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer = "UbuntuServer"
    publisher = "Canonical"
    sku = "18.04-LTS"
    version = "latest"
  }

  tags = merge(map("Name","vmss-${var.region_code}-${var.solution_name}-web"), local.module_common_tags)
}

resource azurerm_monitor_autoscale_setting web {
  name = "mas-${var.region_code}-${var.solution_name}-web"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  target_resource_id = azurerm_linux_virtual_machine_scale_set.web.id

  profile {
    name = "default"

    capacity {
      default = var.min_web_servers
      minimum = var.min_web_servers
      maximum = var.max_web_servers
    }
  }

  tags = merge(map("Name", "mas-${var.region_code}-${var.solution_name}-web"), local.module_common_tags)
}
