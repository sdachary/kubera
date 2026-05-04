class ExportService
  def self.to_csv(user)
    CSV.generate(headers: true) do |csv|
      csv << ["Type", "Name", "Balance", "Status"]
      user.family.accounts.each do |account|
        csv << [account.classification, account.name, account.balance, account.status]
      end
    end
  end

  def self.to_pdf(user)
    # Use prawn or similar for PDF generation
    "PDF export placeholder"
  end
end
