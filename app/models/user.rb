class User < ApplicationRecord
  has_secure_password

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

  scope :active, -> { where(onboarded: true) }

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
end
