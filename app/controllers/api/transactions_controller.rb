class Api::TransactionsController < Api::BaseController
  def show
    transaction = current_user.transactions.find(params[:id])
    render_success(transaction_json(transaction))
  end

  def index
    scope = current_user.transactions.order(transaction_date: :desc)

    scope = scope.where(budget_category_id: params[:budget_category_id]) if params[:budget_category_id]
    scope = scope.where(transaction_type: params[:transaction_type]) if params[:transaction_type]
    scope = scope.where("transaction_date >= ?", params[:start_date]) if params[:start_date]
    scope = scope.where("transaction_date <= ?", params[:end_date]) if params[:end_date]
    scope = scope.uncategorized if params[:uncategorized] == "true"

    page = (params[:page] || 1).to_i
    per = (params[:per] || 50).to_i
    total = scope.count
    transactions = scope.offset((page - 1) * per).limit(per)

    render_success({
      transactions: transactions.map { |t| transaction_json(t) },
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
    render_success(Transaction.monthly_totals(current_user.id, months: months))
  end

  private

  def transaction_params
    source = params[:transaction].presence || params
    source.permit(:description, :amount, :transaction_type, :transaction_date,
                  :budget_category_id, :currency_code, :merchant, :notes,
                  :recurring, :recurring_frequency, :household_id)
  end

  def transaction_json(t)
    { id: t.id, description: t.description, amount: t.amount.to_f,
      transaction_type: t.transaction_type, transaction_date: t.transaction_date,
      currency_code: t.currency_code, currency_symbol: Currency.symbol_for(t.currency_code),
      budget_category_id: t.budget_category_id,
      category_name: t.budget_category&.name,
      merchant: t.merchant, notes: t.notes, recurring: t.recurring,
      created_at: t.created_at }
  end
end
