# frozen_string_literal: true
class MessagesController < ApplicationController
  before_action :set_conversation

  def index
    @messages = @conversation.messages.order(created_at: :asc)
    render json: @messages.map { |m| message_json(m) }
  end

  def create
    @user_message = @conversation.messages.create!(
      role: "user", content: message_params[:content]
    )

    ai = AiService.new(user: current_user)
    response = ai.ask(@user_message.content)

    @ai_message = @conversation.messages.create!(
      role: "assistant", content: response.text
    )

    update_conversation_title(@conversation, @user_message.content)

    respond_to do |format|
      format.turbo_stream
      format.json {
        render json: {
          user: message_json(@user_message),
          assistant: message_json(@ai_message),
          setup: response.setup
        }, status: :created
      }
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.permit(:content)
  end

  def message_json(m)
    { id: m.id, role: m.role, content: m.content, created_at: m.created_at }
  end
end
