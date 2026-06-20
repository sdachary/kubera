class AddGoogleOauthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :avatar_url, :string
    add_column :users, :refresh_token, :text
    add_column :users, :consent_granted, :boolean, default: false
    add_column :users, :consent_granted_at, :datetime
    add_column :users, :deleted_at, :datetime
    add_index :users, :google_uid, unique: true
    change_column_null :users, :password_digest, true
  end
end
