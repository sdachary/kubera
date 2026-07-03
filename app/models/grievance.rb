class Grievance < ApplicationRecord
  belongs_to :user

  TYPES = %w[access correction erasure consent breach marketing other].freeze
  STATUSES = %w[received acknowledged in_review resolved rejected].freeze

  validates :name, :email, :grievance_type, :description, presence: true
  validates :grievance_type, inclusion: { in: TYPES }

  before_create :set_reference_number

  scope :open, -> { where(status: %w[received acknowledged in_review]) }

  private

  def set_reference_number
    self.reference_number ||= "GRF-#{Time.current.strftime('%Y%m')}-#{SecureRandom.hex(4).upcase}"
  end
end
