class Api::TransactionsController < Api::BaseController
  def show
    transaction = current_user.transactions.find(params[:id])
    render_success(transaction_json(transaction))
  end

  def index
    records = current_user.transactions.order(transaction_date: :desc)
    records = records.where(budget_category_id: params[:budget_category_id]) if params[:budget_category_id]
    records = records.where(transaction_type: params[:transaction_type]) if params[:transaction_type]
    records = records.where("transaction_date >= ?", params[:start_date]) if params[:start_date]
    records = records.where("transaction_date <= ?", params[:end_date]) if params[:end_date]
    records = records.uncategorized if params[:uncategorized]
    page = (params[:page] || 1).to_i
    per = (params[:per] || 50).to_i
    total = records.size
    records = records.drop((page - 1) * per).take(per)

    render_success({
      transactions: records.map { |t| transaction_json(t) },
      pagination: { total: total, page: page, per: per }
    })
  end

  def create
    transaction = current_user.transactions.create!(transaction_params)
    render_success(transaction_json(transaction), status: :created)
  end

  def update
    transaction = current_user.transactions.find(params[:id])
    transaction.update!(transaction_params)
    render_success(transaction_json(transaction))
  end

  def destroy
    current_user.transactions.find(params[:id]).destroy!
    head :no_content
  end

  def monthly_totals
    months = (params[:months] || 6).to_i
    transactions = current_user.transactions
    result = (0...months).map do |i|
      date = Date.today - i.months
      month_txns = transactions.select do |t|
        d = t.respond_to?(:transaction_date) ? t.transaction_date : t["transaction_date"]
        d.present? && Date.parse(d.to_s).year == date.year && Date.parse(d.to_s).month == date.month
      end
      expenses = month_txns.select { |t| t.transaction_type.to_s == "expense" }.sum { |t| t.amount.to_f }
      income = month_txns.select { |t| t.transaction_type.to_s == "income" }.sum { |t| t.amount.to_f }
      { month: date.strftime("%Y-%m"), label: date.strftime("%b %Y"),
        expenses: expenses, income: income, net: (income - expenses).round(2) }
    end
    render_success(result)
  end

  private

  def transaction_params
    source = params[:transaction].presence || params
    source.permit(:description, :amount, :transaction_type, :transaction_date,
                  :budget_category_id, :currency_code, :merchant, :notes,
                  :recurring, :recurring_frequency, :household_id)
  end

  def transaction_json(t)
    cc = (t.currency_code.presence || "INR")
    { id: t.id, description: t.description, amount: t.amount.to_f,
      transaction_type: t.transaction_type, transaction_date: t.transaction_date,
      currency_code: cc, currency_symbol: Currency.symbol_for(cc),
      budget_category_id: t.budget_category_id, category_name: nil,
      merchant: t.merchant, notes: t.notes, recurring: t.recurring,
      created_at: t.created_at }
  end
end
