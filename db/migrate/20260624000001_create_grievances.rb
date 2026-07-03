class CreateGrievances < ActiveRecord::Migration[7.2]
  def change
    create_table :grievances, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :grievance_type, null: false
      t.text :description, null: false
      t.string :status, null: false, default: 'received'
      t.string :reference_number
      t.datetime :acknowledged_at
      t.datetime :resolved_at
      t.text :resolution_notes
      t.timestamps
    end
    add_index :grievances, :reference_number, unique: true
    add_index :grievances, [:user_id, :status]
  end
end
