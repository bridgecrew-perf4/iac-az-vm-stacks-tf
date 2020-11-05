# create a key vault SSL certificate
resource azurerm_key_vault_certificate ssl {
  name         = "kvc-${var.region_code}-${var.solution_name}-ssl"
  key_vault_id = azurerm_key_vault.solution.id

  tags = merge(map("Name", "kvc-${var.region_code}-${var.solution_name}-ssl"), local.module_common_tags)

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["${var.solution_name}.azure.msgoat.eu", "*.${var.solution_name}.azure.msgoat.eu"]
      }

      subject            = "CN=${var.organization_name}"
      validity_in_months = 12
    }
  }
}