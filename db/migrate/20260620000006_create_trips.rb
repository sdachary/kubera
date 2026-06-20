class CreateTrips < ActiveRecord::Migration[7.2]
  def change
    create_table :trips, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :destination
      t.date :start_date
      t.date :end_date
      t.string :currency, default: "INR"
      t.string :group_type, default: "friends"
      t.string :status, default: "active"
      t.decimal :total_budget, precision: 12, scale: 2
      t.text :notes

      t.timestamps
    end

    create_table :trip_members, id: :uuid do |t|
      t.references :trip, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :email
      t.string :role, default: "member"
      t.datetime :added_at

      t.timestamps
    end

    add_index :trip_members, [:trip_id, :name], unique: true

    create_table :trip_categories, id: :uuid do |t|
      t.references :trip, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.decimal :budget, precision: 12, scale: 2
      t.string :color, default: "#6B7280"

      t.timestamps
    end

    create_table :trip_expenses, id: :uuid do |t|
      t.references :trip, null: false, foreign_key: true, type: :uuid
      t.references :trip_member, null: false, foreign_key: true, type: :uuid
      t.references :trip_category, null: true, foreign_key: true, type: :uuid
      t.decimal :amount, precision: 12, scale: 2
      t.string :description
      t.date :expense_date
      t.string :split_type, default: "equal"
      t.jsonb :split_details

      t.timestamps
    end

    create_table :trip_settlements, id: :uuid do |t|
      t.references :trip, null: false, foreign_key: true, type: :uuid
      t.references :from_trip_member, null: false, foreign_key: { to_table: :trip_members }, type: :uuid
      t.references :to_trip_member, null: false, foreign_key: { to_table: :trip_members }, type: :uuid
      t.decimal :amount, precision: 12, scale: 2
      t.datetime :settled_at
      t.text :notes

      t.timestamps
    end
  end
end
