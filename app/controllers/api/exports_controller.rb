class Api::ExportsController < Api::BaseController
  FORMATS = %w[csv json].freeze

  def debts
    export = ExportService.new(current_user).export_debts(format: format)
    send_data export, filename: "debts_#{Date.today}.#{format}", type: content_type
  end

  def portfolios
    export = ExportService.new(current_user).export_portfolios(format: format)
    send_data export, filename: "portfolios_#{Date.today}.#{format}", type: content_type
  end

  def transactions
    export = ExportService.new(current_user).export_transactions(
      format: format, start_date: params[:start_date], end_date: params[:end_date]
    )
    send_data export, filename: "transactions_#{Date.today}.#{format}", type: content_type
  end

  def net_worth
    export = ExportService.new(current_user).export_net_worth(format: format)
    send_data export, filename: "net_worth_#{Date.today}.#{format}", type: content_type
  end

  private

  def format
    f = params[:format] || "csv"
    FORMATS.include?(f) ? f : "csv"
  end

  def content_type
    format == "csv" ? "text/csv" : "application/json"
  end
end
