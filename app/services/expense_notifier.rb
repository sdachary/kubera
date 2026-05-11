class ExpenseNotifier
  def self.emi_reminder(debt)
    user = debt.user
    return unless user

    message = "EMI of ₹#{debt.emi_amount} due for #{debt.name}. " \
              "Remaining: ₹#{debt.remaining_amount} (#{debt.months_remaining} months)"

    create_notification(user, "emi_reminder", message)
  end

  def self.recurring_reminder(expense)
    user = expense.user
    return unless user

    due_in = expense.next_due_days
    message = if due_in&.positive?
      "₹#{expense.amount} due for #{expense.name} in #{due_in} day#{due_in == 1 ? "" : "s"}"
    else
      "₹#{expense.amount} due today for #{expense.name}"
    end

    create_notification(user, "recurring_reminder", message)
  end

  def self.create_notification(user, notification_type, message)
    user.notifications.create!(
      notification_type: notification_type,
      message: message
    )
  rescue => e
    Rails.logger.warn "[ExpenseNotifier] Failed to create notification: #{e.message}"
  end
end
