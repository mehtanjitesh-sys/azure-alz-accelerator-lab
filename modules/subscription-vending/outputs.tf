output "subscription_scopes" {
  value = {
    for key, subscription in var.subscriptions : key => "/subscriptions/${subscription.subscription_id}"
  }
}

output "vending_summary" {
  value = {
    for key, subscription in var.subscriptions : key => {
      management_group    = subscription.management_group_name
      environment         = subscription.environment
      data_classification = subscription.data_classification
      monthly_budget      = subscription.monthly_budget
      connectivity        = subscription.connectivity
    }
  }
}

