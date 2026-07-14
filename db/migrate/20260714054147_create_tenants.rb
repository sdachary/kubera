class CreateTenants < ActiveRecord::Migration[7.2]
  def change
    create_table :tenants do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: false
      t.string :name
      t.text :db_url
      t.jsonb :encrypted_api_keys, default: {}
      t.boolean :onboarding_complete, default: false
      t.timestamps
    end

    add_index :tenants, :user_id, unique: true
  end
end
