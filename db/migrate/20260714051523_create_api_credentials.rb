class CreateApiCredentials < ActiveRecord::Migration[7.2]
  def change
    create_table :api_credentials do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: false
      t.string :provider, null: false
      t.string :label
      t.text :encrypted_value, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end
    add_index :api_credentials, [:user_id, :provider], unique: true
  end
end
