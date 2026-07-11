class MessagesController < Api::BaseController
  before_action :set_conversation

  def index
    messages = @conversation.messages.order(created_at: :asc)
    render_success(messages.map { |m| message_json(m) })
  end

  def create
    message = @conversation.messages.create!(message_params)
    render_success(message_json(message), status: :created)
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.permit(:role, :content, metadata: {})
  end

  def message_json(m)
    { id: m.id, role: m.role, content: m.content, metadata: m.metadata, created_at: m.created_at }
  end
end
