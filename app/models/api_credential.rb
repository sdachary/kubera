class ApiCredential < ApplicationRecord
  belongs_to :user

  encrypts :encrypted_value

  validates :provider, presence: true, uniqueness: { scope: :user_id }
  validates :encrypted_value, presence: true
end
