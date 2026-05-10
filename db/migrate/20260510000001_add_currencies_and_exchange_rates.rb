class AddCurrenciesAndExchangeRates < ActiveRecord::Migration[7.2]
  def change
    create_table :currencies, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :symbol, null: false
      t.integer :decimal_places, default: 2
      t.boolean :active, default: true
      t.timestamps
      t.index :code, unique: true
    end

    create_table :exchange_rates, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :from_currency, null: false
      t.string :to_currency, null: false
      t.decimal :rate, precision: 19, scale: 10, null: false
      t.string :source, default: "yahoo_finance"
      t.datetime :fetched_at, null: false
      t.timestamps
      t.index [:from_currency, :to_currency], unique: true
    end
  end
end
