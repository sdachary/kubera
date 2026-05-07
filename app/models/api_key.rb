class ApiKey < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :token_digest, presence: true, uniqueness: true
  validates :display_key, presence: true, uniqueness: true

  scope :active, -> { where(revoked_at: nil).where("expires_at IS NULL OR expires_at > ?", Time.current) }

  has_secure_token :raw_token

  before_create :hash_token
  before_create :set_display_key
  before_create :set_expiry

  def self.authenticate(raw_token)
    token_hash = Argon2::Password.hash(raw_token)
    active.find_by(token_digest: token_hash)
  rescue Argon2::Errors::InvalidHash
    find_by_token_digest(raw_token)
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  private

  def hash_token
    self.token_digest = Argon2::Password.hash(raw_token)
  end

  def set_display_key
    self.display_key = "#{name.parameterize.upcase}_#{raw_token.first(8)}"
  end

  def set_expiry
    self.expires_at ||= 1.year.from_now
  end
end
