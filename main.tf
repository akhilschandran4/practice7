terraform {
  version = "=2.13.0" 
 backend "azurerm" {
  //   storage_account_name = "akhistorage"
  //   container_name       = "akhicontainer"
  //   key                  = "terraform.tfstate"
	// access_key  = "imau4z20XBQuOoHQcAOlx++KKkqCX7khZNvi8hcjvSE3WEVqMlwqJi+2M8/R8TuSg5bQNC8WMmevy97/YeZf1A=="
  features{}
	}
}
provider "azurerm" {
  # subscription_id             = "3457d5d0-1535-40c6-85fb-cb1919104698"
  # client_id                   = "ac2f1e9d-1c78-4921-82ab-b145bb6bfc50"
  # client_certificate_password = "0lY29KJJIAujfH56fkjy6o9C3_JfBubUFM"
  # tenant_id                   = "afe00151-b24a-41de-97f7-be24c523f080"

 # az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/3457d5d0-1535-40c6-85fb-cb1919104698"

   features {}
}
resource "azurerm_resource_group" "rsg" {
  name     = var.resource_name
  location = var.resource_location
}

resource "azurerm_app_service_plan" "app_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rsg.location
  resource_group_name = azurerm_resource_group.rsg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "web_app" {
  name                = var.app_service_name
  location            = azurerm_resource_group.rsg.location
  resource_group_name = azurerm_resource_group.rsg.name
  app_service_plan_id = azurerm_app_service_plan.app_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}