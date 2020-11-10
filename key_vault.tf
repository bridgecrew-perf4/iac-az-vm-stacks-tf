data azurerm_client_config current {
}

resource azurerm_key_vault solution {
  name = "kv-${var.region_code}-${var.solution_name}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  tenant_id = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled = true
  enabled_for_deployment = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  sku_name = "standard"

  # TODO: move out to azurerm_key_vault_access_policy
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "recover",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }

  # TODO: move out to azurerm_key_vault_access_policy
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.loadbalancer.principal_id

    secret_permissions = ["get"]
    certificate_permissions = ["get"]
  }

  tags = merge(map("Name", "kv-${var.region_code}-${var.solution_name}-ssl"), local.module_common_tags)
}
