class AddCurrentAllocationToPortfolios < ActiveRecord::Migration[7.2]
  def change
    add_column :portfolios, :current_allocation, :jsonb, default: {}
  end
end
