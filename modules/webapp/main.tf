resource "azurerm_linux_web_app" "robo_apps" {
  
  name                = var.webapp_name
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = var.service_plan_id
   identity {
    type = "SystemAssigned" # This creates the "user" for the Web App
  }

  site_config {
    # This line tells Azure: "Don't look for a password, use my Identity"
    container_registry_use_managed_identity = true
    application_stack {
      docker_image_name   = var.image_name
      docker_registry_url =  "https://${var.acr_login_server}"
      #"https://roboshopregistry.azurecr.io"
  }
  }

  # USE MERGE FUNCTION: Combines global vars with app-specific vars
  app_settings = merge(
    {
      "WEBSITES_PORT" = "8080"
    },
    var.env_vars
  )
}


/* This block is the "Permission Bridge." By default, even if two resources are in the same subscription, they cannot talk to each other for security reasons.
 The azurerm_role_assignment is what tells Azure: "I trust this specific Web App to go inside this specific Container Registry and pull images."

Why it's mandatory for your project
You enabled SystemAssigned identity on your Web App. This gives your Web App a name/ID in Microsoft Entra (formerly Azure AD), but it starts with zero permissions.

If you don't include this block:

Your Web App will try to pull the image from the ACR.

The ACR will say: "I see who you are, but you don't have an 'AcrPull' ticket."

Your deployment will fail with an Unauthorized or ImagePullBackOff error. */

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.robo_apps.identity[0].principal_id
}
