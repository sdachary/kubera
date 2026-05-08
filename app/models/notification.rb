class Notification < ApplicationRecord
  belongs_to :user

  validates :notification_type, presence: true
  validates :message, presence: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(50) }

  def mark_as_read!
    update!(read: true, read_at: Time.current)
  end
end
