class ResearchAnalysis < TenantRecord
  belongs_to :portfolio

  validates :ticker, presence: true
  validates :status, inclusion: { in: %w[pending processing completed failed] }

  scope :recent, -> { order(researched_at: :desc) }
  scope :successful, -> { where(status: "completed") }
  scope :failed, -> { where(status: "failed") }
  scope :by_ticker, ->(ticker) { where(ticker: ticker).recent }

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  def analysis
    return nil unless ratios_data || statements_data

    Dexter::Analysis.new(ticker: ticker, exchange: exchange, data: {
      "company_name" => company_name,
      "sector" => sector,
      "ratios" => ratios_data,
      "statements" => statements_data,
      "summary" => summary
    })
  end
end
