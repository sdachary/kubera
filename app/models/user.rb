class User < ApplicationRecord
  has_secure_password

  belongs_to :family
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  scope :active, -> { where(active: true) }
end
