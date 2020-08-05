output "id" {
  value = var.module_disabled == true ? null : azurerm_app_service_plan.app_service_plan[0].id
}

output "name" {
  value = var.module_disabled == true ? null : azurerm_app_service_plan.app_service_plan[0].name
}
