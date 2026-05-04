class Api::V1::AiController < Api::V1::BaseController
  before_action :ensure_write_scope

  def chat
    message = params[:message]
    history = params[:history] || []
    
    advisor = AiAdvisor.new(current_resource_owner)
    response = advisor.chat(message, history)
    
    render json: { response: response }
  end

  def analyze_spending
    advisor = AiAdvisor.new(current_resource_owner)
    render json: advisor.analyze_spending
  end

  def recommend_investments
    risk = params[:risk_profile] || 'moderate'
    advisor = AiAdvisor.new(current_resource_owner)
    render json: advisor.investment_recommendations(risk)
  end

  private

  def ensure_write_scope
    authorize_scope!(:write)
  end
end
