# frozen_string_literal: true
class AiService
  def initialize(user:)
    @user = user
  end

  def ask(prompt)
    return handle_setup_flow(prompt) if setup_conversation?(prompt)

    if configured?
      response = call_ai(prompt)
      return AiResponse.new(text: response) if response
    end

    text = rule_response(prompt)
    text += ai_setup_prompt if !configured? && !prompt.to_s.downcase.include?("setup")
    AiResponse.new(text: text)
  end

  def ask_with_actions(prompt)
    result = ask(prompt)

    if result.text.include?("[CREATE_TRANSACTION]")
      create_transaction_from_nl(prompt)
    elsif result.text.include?("[CREATE_BUDGET]")
      create_budget_from_nl(prompt)
    elsif result.text.include?("[CATEGORIZE]")
      categorize_transactions_from_nl(prompt)
    end

    result
  end

  def configured?
    provider_setting.present?
  end

  private

  # ─── Setup Flow ──────────────────────────────────────────────────────

  def setup_conversation?(prompt)
    down = prompt.to_s.downcase
    !configured? && (
      down.include?("setup") || down.include?("configure") ||
      down.include?("enable ai") || down.include?("turn on ai") ||
      down.match?(/\b(ollama|openrouter|api.key|api_key)\b/)
    )
  end

  def handle_setup_flow(prompt)
    down = prompt.to_s.downcase
    sys = SystemDetector.summary

    if down.include?("ollama") && !sys[:ollama_installed]
      return AiResponse.new(
        text: "Ollama isn't installed on your system yet. To install it:\n\n" \
              "1. Visit https://ollama.com and download the installer\n" \
              "2. After installing, run: `ollama pull gemma:2b`\n" \
              "3. Then tell me 'Ollama is ready' and I'll configure Kubera to use it!\n\n" \
              "Your system has #{sys[:ram_mb]}MB RAM — it can run smaller models well.",
        setup: { type: :awaiting_ollama_ready }
      )
    end

    if down.include?("ollama") && sys[:ollama_installed] && !sys[:ollama_running]
      return AiResponse.new(
        text: "Ollama is installed but not running. Can you start it?\n\n" \
              "Open a terminal and run: `ollama serve`\n" \
              "Then pull a model: `ollama pull gemma:2b`\n" \
              "Once it's running, tell me 'Ollama is ready'!",
        setup: { type: :awaiting_ollama_start }
      )
    end

    if down.include?("ollama") && sys[:ollama_running]
      save_setting("ai_provider", "ollama")
      save_setting("ai_model", "gemma:2b")
      save_setting("ai_uri", "http://localhost:11434/v1")
      return AiResponse.new(
        text: "Perfect! I've configured Kubera to use Ollama locally with Gemma 2B. " \
              "Your data stays on your machine — completely private.\n\n" \
              "Now, what financial question can I help you with?",
        setup: { type: :complete, provider: "ollama" }
      )
    end

    if down.include?("openrouter") || down.include?("api key") || down.include?("api_key")
      if down.include?("sk-or-")
        save_setting("ai_provider", "openrouter")
        save_setting("ai_api_key", extract_key(prompt))
        save_setting("ai_model", "google/gemini-2.0-flash-lite-001")
        save_setting("ai_uri", "https://openrouter.ai/api/v1")
        return AiResponse.new(
          text: "Got your OpenRouter key! I've saved it securely. You're all set up.\n\n" \
                "🔒 **Privacy note**: When using cloud AI, your financial summaries " \
                "(debt amounts, portfolio values) are sent to help me answer accurately. " \
                "No personal info (names, emails) is shared.\n\n" \
                "What would you like to work on?",
          setup: { type: :complete, provider: "openrouter" }
        )
      end

      return AiResponse.new(
        text: "To use OpenRouter's free AI:\n\n" \
              "1. Go to https://openrouter.ai/keys\n" \
              "2. Sign up (free) and create a key\n" \
              "3. Paste the key here (it starts with 'sk-or-') and I'll save it\n\n" \
              "The free tier includes models like Gemini Flash — perfect for personal finance.",
        setup: { type: :awaiting_api_key, provider: "openrouter" }
      )
    end

    if down.include?("no") || down.include?("skip") || down.include?("not now")
      save_setting("ai_provider", "disabled")
      return AiResponse.new(
        text: "No problem! I'll use my built-in financial knowledge to help you. " \
              "You can always enable AI later by saying 'setup AI'.",
        setup: { type: :skipped }
      )
    end

    if sys[:local_ai_viable?]
      AiResponse.new(
        text: "Great news! Your system (#{sys[:ram_mb]}MB RAM, #{sys[:cpu_cores]} cores) " \
              "can run a local AI model.\n\n" \
              "**Option 1: Local AI (Ollama)** — Fully private, runs on your machine\n" \
              "**Option 2: OpenRouter (Cloud)** — Smarter models, needs a free API key\n" \
              "**Option 3: No AI** — I'll use built-in financial advice\n\n" \
              "Which sounds best? Just say 'Ollama', 'OpenRouter', or 'skip'.",
        setup: { type: :awaiting_choice }
      )
    else
      AiResponse.new(
        text: "Your system has #{sys[:ram_mb]}MB RAM — not enough for local AI " \
              "(needs 8GB+). But you can still use cloud AI!\n\n" \
              "**Option 1: OpenRouter (Cloud)** — Free tier available, needs API key\n" \
              "**Option 2: No AI** — I'll use built-in financial advice\n\n" \
              "Which sounds best? Say 'OpenRouter' or 'skip'.",
        setup: { type: :awaiting_choice }
      )
    end
  end

  # ─── AI Execution ─────────────────────────────────────────────────────

  def call_ai(prompt)
    client = OpenAI::Client.new(
      access_token: api_token,
      uri_base: ai_uri,
      log_errors: Rails.env.development?
    )

    messages = [
      { role: "system", content: system_prompt },
      { role: "user", content: prompt }
    ]

    response = client.chat(
      parameters: {
        model: ai_model,
        messages: messages,
        temperature: 0.3,
        max_tokens: 1024
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue Faraday::Error, OpenAI::Error => e
    Rails.logger.warn "[AI] API call failed: #{e.message}"
    nil
  end

  def currency_code
    @user.currency.presence || "INR"
  end

  def currency_symbol
    Currency.symbol_for(currency_code)
  end

  def system_prompt
    debts = @user.debts.active
    portfolios = @user.portfolios
    journey = @user.journeys.first
    symbol = currency_symbol
    code = currency_code

    context = []
    if debts.any?
      context << "User's debts: #{debts.map { |d| "#{d.name}: #{symbol}#{d.amount.to_i} at #{d.interest_rate}% (#{d.currency_code})" }.join(', ')}"
    end
    if portfolios.any?
      context << "User's portfolios: #{portfolios.map(&:name).join(', ')} (#{code})"
    end
    if journey
      context << "Journey phase: #{journey.phase}, debt-free target: #{journey.zero_day_target}"
    end
    context << "User's base currency: #{code} (#{symbol})"
    context_str = context.any? ? "\n\nCurrent financial data:\n#{context.join("\n")}" : ""

    provider_notice = if cloud_provider?
      "\n\nPrivacy: This user chose cloud AI. Only share necessary financial data. " \
      "Do not store or log their information beyond this conversation."
    else
      ""
    end

    <<~PROMPT
      You are Kubera, an AI financial freedom assistant. You help users manage their
      personal finances with a "debt-first" philosophy: negative (debt) → zero (free) →
      positive (wealthy).

      The user's base currency is #{code} (#{symbol}). Use #{symbol} or #{code} when
      discussing their finances. The user may have assets and debts in multiple currencies
      (USD, EUR, GBP, INR, etc.) — note the currency when discussing specific items.

      Guidelines:
      - Explain concepts simply, like talking to a friend who isn't tech-savvy
      - Never give specific stock picks — suggest strategies, not securities
      - Support both Indian (NSE/BSE) and international markets (NYSE, NASDAQ, LSE)
      - Keep responses concise and actionable (2-4 paragraphs max)
      - Reference the user's saved financial data when relevant
      - Be encouraging — financial journeys are hard
      - This is a single-user personal finance OS
      #{context_str}
      #{provider_notice}
    PROMPT
  end

  # ─── Rule-based Fallback ──────────────────────────────────────────────

  def rule_response(prompt)
    down = prompt.to_s.downcase

    if transaction_request?(down, prompt)
      create_transaction_from_nl(prompt)
    elsif budget_request?(down)
      create_budget_from_nl(prompt)
    elsif categorize_request?(down)
      categorize_recent_transactions(prompt)
    elsif anomaly_request?(down)
      anomaly_report
    elsif forecast_request?(down)
      cash_flow_forecast
    elsif export_request?(down)
      export_instructions
    elsif down.include?("debt") || down.include?("loan") || down.include?("emi") || down.include?("credit card")
      debt_advice
    elsif down.include?("invest") || down.include?("sip") || down.include?("dividend") || down.include?("stock")
      invest_advice
    elsif down.include?("budget") || down.include?("expense") || down.include?("spend") || down.include?("save")
      budget_advice
    elsif down.include?("overview") || down.include?("summary") || down.include?("net worth")
      overview
    elsif down.match?(/\b(hi|hello|hey)\b/) && prompt.length < 20
      greeting
    else
      general_fallback(prompt)
    end
  end

  def transaction_request?(down, prompt)
    amounts = prompt.scan(/[\d,.]+/)
    (down.include?("spent") || down.include?("paid") || down.include?("earned") ||
     down.include?("received") || down.include?("bought") || down.include?("purchased")) &&
     amounts.any? { |a| a.gsub(/[,.]/, "").to_i > 0 }
  end

  def budget_request?(down)
    down.include?("set a budget") || down.include?("create a budget") ||
    down.include?("budget for") || (down.include?("limit") && down.include?("category"))
  end

  def categorize_request?(down)
    (down.include?("categorize") || down.include?("sort") || down.include?("organize")) &&
    (down.include?("transaction") || down.include?("expense") || down.include?("spending"))
  end

  def anomaly_request?(down)
    down.include?("anomaly") || down.include?("unusual") || down.include?("abnormal") ||
    down.include?("suspicious") || down.include?("detect") || down.include?("irregular")
  end

  def forecast_request?(down)
    down.include?("forecast") || down.include?("projection") || down.include?("predict") ||
    down.include?("future") || (down.include?("cash flow") && down.include?("look"))
  end

  def export_request?(down)
    down.include?("export") || down.include?("download") ||
    (down.include?("generate") && (down.include?("report") || down.include?("csv")))
  end

  def sym
    currency_symbol
  end

  def debt_advice
    debts = @user.debts.active
    return "You don't have any debts tracked yet. Want to add one? Just tell me the name, amount, and interest rate!" if debts.empty?

    total = debts.sum(&:amount)
    highest = debts.max_by(&:interest_rate)
    lowest = debts.min_by(&:amount)

    text = "You have #{debts.count} active #{'debt'.pluralize(debts.count)} totaling #{sym}#{format_rupee(total)}.\n\n"
    text += "**Strategy**: Since your highest interest debt is #{highest.name} at #{highest.interest_rate}%, "
    text += "I recommend the **avalanche method** — pay minimum on everything, "
    text += "put extra toward #{highest.name} first. It saves the most in interest.\n\n"
    text += "Alternatively, the **snowball method** (pay off #{lowest.name} first — #{sym}#{format_rupee(lowest.amount)} — for quick wins) " if lowest != highest
    text += "\nWant me to create a detailed payoff plan?"
    text
  end

  def invest_advice
    portfolios = @user.portfolios
    return "You don't have any investment portfolios yet. Want to start one? " \
           "A monthly SIP of #{sym}5,000 in large-cap stocks is a great beginning." if portfolios.empty?

    total = portfolios.sum(&:total_value)
    "You have #{portfolios.count} portfolio(s) worth #{sym}#{format_rupee(total)}.\n\n" \
    "For dividend investing:\n" \
    "• Look for companies with 5+ years of consistent dividends\n" \
    "• Target dividend yield of 2-4%\n" \
    "• Reinvest dividends to compound returns\n\n" \
    "Want me to suggest a SIP allocation for your portfolio?"
  end

  def budget_advice
    expenses = @user.recurring_expenses.active
    return "No recurring expenses tracked yet. List your monthly bills and I'll help you optimize!" if expenses.empty?

    total = expenses.sum(&:monthly_amount)
    "You have #{expenses.count} recurring #{'expense'.pluralize(expenses.count)} at #{sym}#{format_rupee(total)}/month.\n\n" \
    "**50/30/20 rule**:\n" \
    "• 50% Needs (#{sym}#{format_rupee((total * 0.5).round)})\n" \
    "• 30% Wants (#{sym}#{format_rupee((total * 0.3).round)})\n" \
    "• 20% Savings (#{sym}#{format_rupee((total * 0.2).round)})\n\n" \
    "Does your current spending match this? Want to review specific categories?"
  end

  def overview
    debts = @user.debts.active
    portfolios = @user.portfolios
    expenses = @user.recurring_expenses.active
    journey = @user.journeys.first

    parts = ["Here's your financial snapshot:\n"]
    total_debt = debts.sum(&:amount)
    total_inv = portfolios.sum(&:total_value)
    net = total_inv - total_debt
    parts << "💰 **Net Worth**: #{sym}#{format_rupee(net)} (#{net >= 0 ? '✅ positive' : '⚠️ negative'})"
    parts << "💳 **Debt**: #{sym}#{format_rupee(total_debt)} (#{debts.count} active)" if debts.any?
    parts << "📈 **Investments**: #{sym}#{format_rupee(total_inv)}" if portfolios.any?
    parts << "📅 **Monthly Expenses**: #{sym}#{format_rupee(expenses.sum(&:monthly_amount))}" if expenses.any?
    if journey&.zero_day_target
      parts << "🎯 **Debt Free**: #{journey.zero_day_target.strftime('%b %Y')} (#{(journey.zero_day_target - Date.today).to_i} days)"
    end
    parts.join("\n")
  end

  def format_rupee(amount)
    int = amount.to_i.to_s
    return int if int.length <= 3
    last3 = int[-3..]
    front = int[0...-3]
    front = front.reverse.gsub(/(\d{2})(?=\d)/, '\\1,').reverse
    "#{front},#{last3}"
  end

  def greeting
    name = [@user.first_name, @user.last_name].compact.first
    greeting = name ? "Welcome back, #{name}!" : "Welcome to Kubera!"
    "#{greeting} I'm your financial freedom assistant.\n\n" \
    "Tell me about your finances and I'll help you plan your journey from debt to wealth. " \
    "Try saying: \"I have a credit card debt\" or \"Show me my overview\"."
  end

  # ─── NL Transaction Creation ──────────────────────────────────────────

  def create_transaction_from_nl(prompt)
    amounts = prompt.scan(/[\d,.]+/).map { |a| a.gsub(/[,\s]/, "").to_f }.reject(&:zero?)
    return "I couldn't find an amount in your message. Try: \"I spent ₹500 on groceries\"" if amounts.empty?

    amount = amounts.first
    type = expense_income_type(prompt)
    description = extract_description(prompt)
    category = extract_category(prompt)

    transaction = @user.transactions.create!(
      description: description,
      amount: amount,
      transaction_type: type,
      transaction_date: Date.today,
      currency_code: @user.currency,
      budget_category: category
    )

    cat_name = category&.name || "Uncategorized"
    "✅ Recorded: #{type == 'expense' ? 'Spent' : 'Received'} #{sym}#{format_rupee(amount)} on #{description} (#{cat_name})"
  rescue ActiveRecord::RecordInvalid => e
    "Sorry, I couldn't save that transaction: #{e.message}"
  end

  def create_budget_from_nl(prompt)
    amounts = prompt.scan(/[\d,.]+/).map { |a| a.gsub(/[,\s]/, "").to_f }.reject(&:zero?)
    return "I couldn't find a budget amount. Try: \"Set a ₹10,000 budget for Food\"" if amounts.empty?

    amount = amounts.first
    cat_name = extract_category_name(prompt)
    category = BudgetCategory.find_or_create_by!(user: @user, name: cat_name) do |c|
      c.sort_order = BudgetCategory::DEFAULT_CATEGORIES.index(cat_name) || 99
      c.color = BudgetCategory.category_colors[rand(BudgetCategory.category_colors.length)]
    end

    budget = @user.budgets.create!(
      budget_category: category,
      monthly_limit: amount,
      currency_code: @user.currency,
      period: "monthly"
    )

    "✅ Budget set: #{sym}#{format_rupee(amount)}/month for #{category.name}"
  rescue ActiveRecord::RecordInvalid => e
    "Sorry, I couldn't create that budget: #{e.message}"
  end

  def categorize_recent_transactions(prompt)
    uncategorized = @user.transactions.uncategorized.recent.limit(20)
    return "No uncategorized transactions found!" if uncategorized.empty?

    categorized = 0
    uncategorized.each do |t|
      cat = suggest_category(t)
      if cat
        t.update!(budget_category: cat)
        categorized += 1
      end
    end

    "✅ Categorized #{categorized} transactions. #{uncategorized.count - categorized} need manual review."
  end

  def anomaly_report
    anomalies = AnomalyDetectionService.new(@user).detect

    if anomalies.empty?
      return "✅ No anomalies detected! Your spending patterns look normal."
    end

    text = "⚠️ #{anomalies.length} anomaly(ies) detected:\n\n"
    anomalies.first(5).each do |a|
      icon = a[:severity] >= 8 ? "🔴" : a[:severity] >= 4 ? "🟡" : "🟢"
      text += "#{icon} **#{a[:title]}**: #{a[:description]}\n"
    end
    if anomalies.length > 5
      text += "\n...and #{anomalies.length - 5} more. Check your dashboard for details."
    end
    text
  end

  def cash_flow_forecast
    forecast = CashFlowForecastService.new(@user).summary

    text = "📊 **Cash Flow Forecast**\n\n"
    text += "Monthly Income: #{sym}#{format_rupee(forecast[:monthly_income])}\n"
    text += "Monthly Expenses: #{sym}#{format_rupee(forecast[:monthly_expenses])}\n"
    text += "Net: #{sym}#{format_rupee(forecast[:net_monthly])}\n"
    text += "Health: #{forecast[:health].upcase}\n"
    if forecast[:runway_months]
      text += "⚠️ At current burn rate, savings will last #{forecast[:runway_months]} months\n"
    end
    text
  end

  def export_instructions
    "📁 **Export Options**:\n\n" \
    "• Say \"export my debts\" for CSV\n" \
    "• Say \"export transactions\" for CSV\n" \
    "• Say \"export portfolio\" for CSV\n" \
    "• Say \"export net worth\" for CSV\n" \
    "• Say \"generate annual report\" for a full-year summary\n\n" \
    "Exports are available from the Reports section of your dashboard."
  end

  private

  def expense_income_type(prompt)
    down = prompt.to_s.downcase
    if down.include?("earned") || down.include?("received") || down.include?("salary") ||
       down.include?("income") || down.include?("deposited") || down.include?("paid me")
      "income"
    else
      "expense"
    end
  end

  def extract_description(prompt)
    prompt = prompt.to_s
    prompt = prompt.gsub(/\b(spent|paid|earned|received|bought|purchased|for|on)\b/i, "")
    prompt = prompt.gsub(/[\d,. ₹$€£¥]+/, "").strip
    prompt = prompt.gsub(/\b(anomaly|unusual|abnormal|suspicious)\b/i, "").strip
    prompt = prompt.gsub(/\b(setup|configure|ai|ollama|openrouter)\b/i, "").strip
    prompt.presence || "General expense"
  end

  def extract_category(prompt)
    down = prompt.to_s.downcase
    BudgetCategory.where(user: @user).active.each do |cat|
      return cat if down.include?(cat.name.downcase)
    end
    nil
  end

  def extract_category_name(prompt)
    down = prompt.to_s.downcase
    BudgetCategory::DEFAULT_CATEGORIES.each do |name|
      return name if down.include?(name.downcase)
    end
    "Other"
  end

  def suggest_category(transaction)
    desc = transaction.description.to_s.downcase

    keywords = {
      "Food" => %w[food restaurant grocery cafe lunch dinner snack zomato swiggy],
      "Transport" => %w[uber ola petrol fuel taxi bus train metro parking],
      "Utilities" => %w[electricity water gas bill broadband phone mobile],
      "Rent" => %w[rent lease apartment housing],
      "Entertainment" => %w[movie netflix spotify amazon prime game music],
      "Healthcare" => %w[hospital doctor medicine pharmacy clinic health],
      "Shopping" => %w[amazon flipkart cloth shoe apparel purchase],
      "Education" => %w[course book udemy coursera tuition fee class],
      "Insurance" => %w[insurance premium policy],
      "Savings" => %w[savings deposit fd fixed recurring rd],
      "Salary" => %w[salary payroll wage income],
      "Freelance" => %w[freelance contract project payment upwork fiverr],
      "Business" => %w[business revenue invoice vendor supplier]
    }

    keywords.each do |category, words|
      return BudgetCategory.find_or_create_by!(user: @user, name: category) if words.any? { |w| desc.include?(w) }
    end

    nil
  end

  def ai_setup_prompt
    "\n\n💡 **Want smarter AI-powered answers?** " \
    "Say **'setup'** and I'll check your system and help you configure AI " \
    "(local or cloud, whatever works best for you)."
  end

  # ─── Helpers ──────────────────────────────────────────────────────────

  def provider_setting
    Setting.get("ai_provider", user: @user)
  end

  def api_token
    if cloud_provider?
      ENV["OPENAI_ACCESS_TOKEN"].presence || Setting.get("ai_api_key", user: @user)
    else
      "ollama"
    end
  end

  def ai_uri
    Setting.get("ai_uri", user: @user).presence ||
      ENV["OPENAI_URI_BASE"].presence ||
      "http://localhost:11434/v1"
  end

  def ai_model
    Setting.get("ai_model", user: @user).presence ||
      ENV["OPENAI_MODEL"].presence ||
      "gemma:2b"
  end

  def cloud_provider?
    Setting.get("ai_provider", user: @user) == "openrouter"
  end

  def save_setting(key, value)
    Setting.set(key, value, user: @user)
  end

  def extract_key(text)
    text[/sk-or-[a-zA-Z0-9]{32,}/] || text[/sk-[a-zA-Z0-9]{32,}/] || text.strip
  end

end
