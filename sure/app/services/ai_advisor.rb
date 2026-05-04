class AiAdvisor
  def initialize(user, ai_client = nil)
    @user = user
    @client = ai_client || OpenRouterClient.new
  end

  def chat(message, history = [])
    prompt = build_prompt(message, history)
    @client.chat(prompt)
  end

  def analyze_spending
    # Analyze spending patterns
    { patterns: [], insights: [] }
  end

  def investment_recommendations(risk_profile = 'moderate')
    # AI-powered investment suggestions
    { recommendations: [], reasoning: '' }
  end

  def tax_optimization
    # Tax saving suggestions
    { suggestions: [], estimated_savings: 0 }
  end

  private

  def build_prompt(message, history)
    context = gather_financial_context
    "
    You are a financial advisor. User context: #{context}
    History: #{history}
    User: #{message}
    "
  end

  def gather_financial_context
    tracker = WealthJourneyTracker.new(@user)
    {
      debt: tracker.debt_progress,
      net_worth: tracker.net_worth_trajectory,
      sip: tracker.sip_progress
    }.to_json
  end
end
