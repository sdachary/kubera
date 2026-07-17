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
    total = records.count
    records = records.limit(per).offset((page - 1) * per)

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
    start_date = (months - 1).months.ago.beginning_of_month
    txns = current_user.transactions
      .where(transaction_date: start_date..)
      .group("date_trunc('month', transaction_date)")
      .select("date_trunc('month', transaction_date) as month,
               sum(case when transaction_type = 'expense' then amount else 0 end) as expenses,
               sum(case when transaction_type = 'income' then amount else 0 end) as income")
      .order("month")
    grouped = txns.index_by { |t| t.month.strftime("%Y-%m") }
    result = (0...months).map do |i|
      date = Date.today - i.months
      key = date.strftime("%Y-%m")
      if grouped[key]
        { month: key, label: date.strftime("%b %Y"),
          expenses: grouped[key].expenses.to_f, income: grouped[key].income.to_f,
          net: (grouped[key].income.to_f - grouped[key].expenses.to_f).round(2) }
      else
        { month: key, label: date.strftime("%b %Y"), expenses: 0, income: 0, net: 0 }
      end
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
