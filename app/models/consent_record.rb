class ConsentRecord < ApplicationRecord
  belongs_to :user

  FEATURES = %w[financial_tracking trip_data email_updates marketing].freeze

  validates :feature, inclusion: { in: FEATURES }
  validates :granted, inclusion: { in: [true, false] }

  scope :active, -> { where(granted: true).where(revoked_at: nil) }
end
