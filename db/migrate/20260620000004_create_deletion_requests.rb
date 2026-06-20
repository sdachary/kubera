class CreateDeletionRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :deletion_requests, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :status, null: false, default: 'pending'
      t.string :cancel_token, null: false
      t.boolean :export_data, default: true
      t.datetime :scheduled_for, null: false
      t.datetime :deleted_at
      t.text :notes
      t.timestamps
    end
    add_index :deletion_requests, :cancel_token, unique: true
    add_index :deletion_requests, [:user_id, :status]
  end
end
