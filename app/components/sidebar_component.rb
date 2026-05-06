class SidebarComponent < ViewComponent::Base
  def initialize(current_path:)
    @current_path = current_path
  end

  def nav_items
    [
      { name: "Dashboard", path: "/", icon: "layout-dashboard" },
      { name: "Debt Payoff", path: "/debt-payoff", icon: "banknote" },
      { name: "SIP Planner", path: "/sip-planner", icon: "line-chart" },
      { name: "Portfolio", path: "/portfolio", icon: "pie-chart" },
      { name: "Recurring Expenses", path: "/recurring-expenses", icon: "repeat" }
    ]
  end

  def active?(path)
    @current_path == path
  end
end
