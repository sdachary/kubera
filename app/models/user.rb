class User < ApplicationRecord
  has_secure_password validations: false

  STORAGE_BACKENDS = %w[local google_sheets].freeze

  has_many :conversations, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :consent_records, dependent: :destroy
  has_many :deletion_requests, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :debt_payoffs, dependent: :destroy
  has_many :portfolios, dependent: :destroy
  has_many :journeys, dependent: :destroy
  has_many :net_worth_snapshots, dependent: :destroy
  has_many :recurring_expenses, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :settings, dependent: :destroy
  has_many :budget_categories, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :trips, dependent: :destroy
  has_many :research_analyses, through: :portfolios
  has_many :household_memberships, dependent: :destroy
  has_many :households, through: :household_memberships

  validates :email, presence: true, uniqueness: true
  validates :storage_backend, inclusion: { in: STORAGE_BACKENDS }
  validates :password, length: { minimum: 8 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?

  before_save :downcase_email

  scope :active, -> { where(onboarded: true) }

  def storage
    @storage ||= StorageProvider.for(self)
  end

  def self.from_google(auth)
    where(google_uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.avatar_url = auth.info.image
      user.password_digest = nil
      user.refresh_token = auth.credentials.refresh_token
    end
  end

  def self.from_github(auth)
    where(github_uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.name&.split&.first || auth.info.nickname
      user.last_name = auth.info.name&.split&.drop(1)&.join(" ") if auth.info.name&.split&.size&.> 1
      user.avatar_url = auth.info.image
      user.password_digest = nil
      user.github_token = auth.credentials.token
    end
  end

  def self.find_by_password_reset_token(token)
    find_by(password_reset_token: token)
  end

  def generate_password_reset_token
    token = SecureRandom.urlsafe_base64(32)
    update!(
      password_reset_token: token,
      password_reset_sent_at: Time.current
    )
    token
  end

  def password_reset_expired?
    password_reset_sent_at.nil? || password_reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def password_required?
    password_digest.nil? || password.present?
  end
end
