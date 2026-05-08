class Api::NotificationsController < Api::BaseController
  def index
    notifications = current_user.notifications.recent
    render json: notifications.map { |n| notification_json(n) }
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!
    render json: notification_json(notification)
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read: true, read_at: Time.current)
    head :ok
  end

  private

  def notification_json(n)
    { id: n.id, notification_type: n.notification_type, message: n.message,
      read: n.read, read_at: n.read_at, metadata: n.metadata, created_at: n.created_at }
  end
end
