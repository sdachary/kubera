class CreateConsentRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :consent_records, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :feature, null: false
      t.boolean :granted, null: false
      t.string :ip_address
      t.string :user_agent
      t.datetime :granted_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :revoked_at
      t.timestamps
    end
    add_index :consent_records, [:user_id, :feature]
  end
end
