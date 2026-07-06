class Api::BudgetCategoriesController < Api::BaseController
  def index
    categories = storage.list_budget_categories
    active = categories.select { |c| c.active.to_s != "false" }
    render_success(active.map { |c| category_json(c) })
  end

  def create
    cat = storage.create_budget_category(attrs: category_params)
    render_success(category_json(cat), status: :created)
  end

  def update
    cat = storage.update_budget_category(id: params[:id], attrs: category_params)
    render_success(category_json(cat))
  end

  def destroy
    storage.delete_budget_category(id: params[:id])
    head :no_content
  end

  def seed
    BudgetCategory.seed_for(current_user)
    categories = storage.list_budget_categories
    active = categories.select { |c| c.active.to_s != "false" }
    render_success(active.map { |c| category_json(c) })
  end

  private

  def category_params
    params.permit(:name, :icon, :color, :sort_order, :active)
  end

  def category_json(c)
    { id: c.id, name: c.name, icon: c.icon, color: c.color,
      sort_order: c.sort_order, active: c.active,
      transaction_count: 0 }
  end
end
