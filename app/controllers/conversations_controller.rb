class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :destroy]

  def index
    @conversations = current_user.conversations.order(created_at: :desc)
    render json: @conversations.map { |c|
      { id: c.id, title: c.title, message_count: c.messages.count,
        last_message: c.messages.last&.content&.truncate(80), created_at: c.created_at }
    }
  end

  def show
    @messages = @conversation.messages.order(created_at: :asc)
    render json: {
      conversation: { id: @conversation.id, title: @conversation.title,
                      summary: @conversation.summary },
      messages: @messages.map { |m|
        { id: m.id, role: m.role, content: m.content, created_at: m.created_at }
      }
    }
  end

  def create
    @conversation = current_user.conversations.create!(
      title: conversation_params[:title] || "New Conversation"
    )
    render json: { id: @conversation.id, title: @conversation.title }, status: :created
  end

  def destroy
    @conversation.destroy!
    head :no_content
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def conversation_params
    params.permit(:title)
  end
end
