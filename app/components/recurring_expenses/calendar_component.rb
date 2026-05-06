class RecurringExpenses::CalendarComponent < ViewComponent::Base
  def initialize(year: nil, month: nil, expenses: nil)
    @date = Date.new(year || Time.current.year, month || Time.current.month, 1)
    @expenses = expenses || default_expenses
    @selected_date = Time.current.to_date
  end

  def current_month_name
    @date.strftime("%B %Y")
  end

  def days_in_month
    @date.end_of_month.day
  end

  def first_day_of_month
    @date.beginning_of_month.wday
  end

  def expenses_for_day(day)
    date = Date.new(@date.year, @date.month, day)
    @expenses.select { |e| recurring_on_date?(e, date) }
  end

  def total_monthly_expenses
    @expenses.sum { |e| e[:amount] }
  end

  def upcoming_expenses
    today = Time.current.to_date
    @expenses.select { |e| next_occurrence(e[:frequency], today) >= today }
              .sort_by { |e| next_occurrence(e[:frequency], today) }
              .first(5)
  end

  def category_color(category)
    case category
    when "Entertainment" then "purple"
    when "Utilities" then "blue"
    when "Health" then "green"
    when "Insurance" then "yellow"
    when "Investment" then "indigo"
    else "gray"
    end
  end

  def category_icon(category)
    case category
    when "Entertainment" then "film"
    when "Utilities" then "zap"
    when "Health" then "heart"
    when "Insurance" then "shield"
    when "Investment" then "trending-up"
    else "circle"
    end
  end

  private

  def default_expenses
    [
      { name: "Netflix Subscription", amount: 649.0, frequency: "monthly", category: "Entertainment", day_of_month: 5 },
      { name: "Electricity Bill", amount: 2500.0, frequency: "monthly", category: "Utilities", day_of_month: 10 },
      { name: "Internet Bill", amount: 999.0, frequency: "monthly", category: "Utilities", day_of_month: 12 },
      { name: "Gym Membership", amount: 1500.0, frequency: "monthly", category: "Health", day_of_month: 15 },
      { name: "Spotify Premium", amount: 119.0, frequency: "monthly", category: "Entertainment", day_of_month: 18 },
      { name: "Insurance Premium", amount: 5000.0, frequency: "quarterly", category: "Insurance", day_of_month: 1 },
      { name: "Mutual Fund SIP", amount: 10000.0, frequency: "monthly", category: "Investment", day_of_month: 7 }
    ]
  end

  def recurring_on_date?(expense, date)
    case expense[:frequency]
    when "monthly"
      date.day == expense[:day_of_month]
    when "quarterly"
      date.day == expense[:day_of_month] && date.month % 3 == expense[:day_of_month] % 3
    when "yearly"
      date.day == expense[:day_of_month] && date.month == @date.month
    else
      false
    end
  end

  def next_occurrence(frequency, from_date)
    case frequency
    when "monthly"
      Date.new(from_date.year, from_date.month, [from_date.day, 28].min) + 1.month
    when "quarterly"
      from_date + 3.months
    when "yearly"
      from_date + 1.year
    else
      from_date
    end
  end
end
