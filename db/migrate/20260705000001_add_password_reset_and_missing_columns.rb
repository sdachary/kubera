class AddPasswordResetAndMissingColumns < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :google_uid, :string unless column_exists?(:users, :google_uid)
    add_column :users, :avatar_url, :string unless column_exists?(:users, :avatar_url)
    add_column :users, :refresh_token, :text unless column_exists?(:users, :refresh_token)
    add_column :users, :consent_granted, :boolean, default: false unless column_exists?(:users, :consent_granted)
    add_column :users, :consent_granted_at, :datetime unless column_exists?(:users, :consent_granted_at)
    add_column :users, :deleted_at, :datetime unless column_exists?(:users, :deleted_at)
    add_column :users, :encrypted_email, :string unless column_exists?(:users, :encrypted_email)
    add_column :users, :encrypted_email_iv, :string unless column_exists?(:users, :encrypted_email_iv)
    add_column :users, :password_reset_token, :string unless column_exists?(:users, :password_reset_token)
    add_column :users, :password_reset_sent_at, :datetime unless column_exists?(:users, :password_reset_sent_at)
    add_index :users, :google_uid, unique: true unless index_exists?(:users, :google_uid)
    add_index :users, :password_reset_token, unique: true unless index_exists?(:users, :password_reset_token)
  end
end
