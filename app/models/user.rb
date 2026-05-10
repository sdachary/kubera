class User < ApplicationRecord
  has_secure_password

  has_many :conversations, dependent: :destroy
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
  has_many :household_memberships, dependent: :destroy
  has_many :households, through: :household_memberships

  validates :email, presence: true, uniqueness: true

  scope :active, -> { where(onboarded: true) }
end
