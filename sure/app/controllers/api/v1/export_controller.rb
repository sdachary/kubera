class Api::V1::ExportController < Api::V1::BaseController
  before_action :ensure_read_scope

  def csv
    csv_data = ExportService.to_csv(current_resource_owner)
    send_data csv_data, filename: "kubera-financial-plan-#{Date.today}.csv"
  end

  def pdf
    pdf_data = ExportService.to_pdf(current_resource_owner)
    send_data pdf_data, filename: "kubera-financial-plan-#{Date.today}.pdf"
  end

  private

  def ensure_read_scope
    authorize_scope!(:read)
  end
end
