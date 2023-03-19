# App Network Group
resource "azurerm_network_manager_network_group" "apps" {
  name               = "app-dynamic-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_policy_definition" "anm_app_ng_policy" {
  name         = "anm-app-ng-policy"
  display_name = "ANM App Dynamic NG Policy"
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  policy_rule  = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          {
            "allOf": [
              {
                "field": "Name",
                "contains": "app"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.apps.id}"
        }
      }
    }
    POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "app" {
  name                 = "anm-app-ng-policy-assignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.anm_app_ng_policy.id
}

# East2 Network Group
resource "azurerm_network_manager_network_group" "east2" {
  name               = "east2-spoke-dynamic-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_policy_definition" "anm_east2_ng_policy" {
  name         = "anm-east2-ng-policy"
  display_name = "ANM East2 Dynamic NG Policy"
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  policy_rule  = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          {
            "field": "location",
            "equals": "eastus2"
          },
          {
            "anyOf": [
              {
                "field": "name",
                "contains": "shared"
              },
              {
                "field": "name",
                "contains": "core"
              },
              {
                "field": "name",
                "contains": "app"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.east2.id}"
        }
      }
    }
    POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "east2" {
  name                 = "anm-east2-ng-policy-assignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.anm_east2_ng_policy.id
}

# West2 Network Group
resource "azurerm_network_manager_network_group" "west2" {
  name               = "west2-spoke-dynamic-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_policy_definition" "anm_west2_ng_policy" {
  name         = "anm-west2-ng-policy"
  display_name = "ANM west2 Dynamic NG Policy"
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  policy_rule  = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          {
            "field": "location",
            "equals": "westus2"
          },
          {
            "anyOf": [
              {
                "field": "name",
                "contains": "shared"
              },
              {
                "field": "name",
                "contains": "core"
              },
              {
                "field": "name",
                "contains": "app"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.west2.id}"
        }
      }
    }
    POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "west2" {
  name                 = "anm-west2-ng-policy-assignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.anm_west2_ng_policy.id
}

# East Network Group
resource "azurerm_network_manager_network_group" "east" {
  name               = "east-spoke-dynamic-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_policy_definition" "anm_east_ng_policy" {
  name         = "anm-east-ng-policy"
  display_name = "ANM east Dynamic NG Policy"
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  policy_rule  = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          {
            "allOf": [
              {
                "field": "location",
                "equals": "eastus"
              }
            ]
          },
          {
            "anyOf": [
              {
                "field": "name",
                "contains": "shared"
              },
              {
                "field": "name",
                "contains": "core"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.east.id}"
        }
      }
    }
    POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "east" {
  name                 = "anm-east-ng-policy-assignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.anm_east_ng_policy.id
}

# West Network Group
resource "azurerm_network_manager_network_group" "west" {
  name               = "west-spoke-dynamic-ng"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_policy_definition" "anm_west_ng_policy" {
  name         = "anm-west-ng-policy"
  display_name = "ANM west Dynamic NG Policy"
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  policy_rule  = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          {
            "allOf": [
              {
                "field": "location",
                "equals": "westus"
              }
            ]
          },
          {
            "anyOf": [
              {
                "field": "name",
                "contains": "shared"
              },
              {
                "field": "name",
                "contains": "core"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.west.id}"
        }
      }
    }
    POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "west" {
  name                 = "anm-west-ng-policy-assignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.anm_west_ng_policy.id
}