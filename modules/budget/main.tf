resource "azurerm_consumption_budget_resource_group" "dev_budget" {
  name = "${var.resource_name}-dev-budget"
  resource_group_id = var.resource_group_id
  amount = 1
  time_grain = "Monthly"

  time_period {
    start_date = "024-01-01T00:00:00Z"
  }

  notification {
    threshold = 80
    operator = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = [ "kiendolorfo@gmail.com" ]
  }
}