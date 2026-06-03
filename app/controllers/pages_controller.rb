class PagesController < ApplicationController
  layout "application"

  skip_before_action :require_onboarding, only: [:privacy, :security]

  def privacy
  end

  def security
  end

  def dashboard
    @conversation = find_or_create_conversation
    @messages = @conversation.messages.order(created_at: :asc)
    @conversations = current_user.conversations.order(created_at: :desc)

    @total_debt = current_user.debts.active.sum(:amount).to_f
    @total_investments = current_user.portfolios.sum(:total_value).to_f
    @net_worth = @total_investments - @total_debt
    @monthly_expenses = current_user.recurring_expenses.active.sum(:monthly_amount)
    @journey = current_user.journeys.first
    @base_currency = current_user.currency
    @currency_symbol = Currency.symbol_for(@base_currency)
  end

  private

  def find_or_create_conversation
    if params[:conversation_id]
      current_user.conversations.find(params[:conversation_id])
    else
      current_user.conversations.order(created_at: :desc).first ||
        current_user.conversations.create!(title: "Financial Freedom")
    end
  end
end
