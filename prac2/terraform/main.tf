provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "demo-cluster"
  location            = "eastus"
  resource_group_name = "demo-rg"
  dns_prefix          = "demo"

  default_node_pool {
    name       = "nodepool"
    node_count = 1
    vm_size    = "Standard_B2ms"
  }

  identity {
    type = "SystemAssigned"
  }
}
