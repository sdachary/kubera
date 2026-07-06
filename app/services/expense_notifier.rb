class ExpenseNotifier
  def self.emi_reminder(debt)
    user = debt.user
    return unless user
    NotificationService.new(user).notify_debt_milestone(debt, "EMI Reminder")
  end

  def self.recurring_reminder(expense)
    user = expense.user
    return unless user
    NotificationService.new(user).notify_sip_reminder(expense)
  end
end
