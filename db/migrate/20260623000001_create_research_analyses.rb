class CreateResearchAnalyses < ActiveRecord::Migration[7.2]
  def change
    create_table :research_analyses do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.string :ticker, null: false
      t.string :exchange, default: "US"
      t.string :company_name
      t.string :sector
      t.text :summary
      t.jsonb :ratios_data
      t.jsonb :statements_data
      t.string :status, default: "pending"
      t.text :error_message
      t.datetime :researched_at

      t.timestamps
    end

    add_index :research_analyses, [:portfolio_id, :ticker]
    add_index :research_analyses, :status
  end
end
