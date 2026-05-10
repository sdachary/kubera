class Api::ReportsController < Api::BaseController
  def annual
    year = (params[:year] || Date.today.year).to_i
    report = AnnualReportService.new(current_user, year: year).generate
    render json: report
  end

  def cash_flow_forecast
    months = (params[:months] || 12).to_i
    service = CashFlowForecastService.new(current_user)
    render json: {
      summary: service.summary,
      forecast: service.forecast(months: months)
    }
  end

  def anomalies
    service = AnomalyDetectionService.new(current_user)
    render json: service.summary
  end

  def goal_charts
    service = GoalChartService.new(current_user)
    render json: {
      debt_free_progress: service.debt_free_progress,
      wealth_growth: service.wealth_growth,
      budget_chart: service.monthly_budget_chart,
      income_vs_expenses: service.income_vs_expenses
    }
  end
end
