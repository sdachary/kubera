class AddEncryptionToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :encrypted_email, :string
    add_column :users, :encrypted_email_iv, :string
  end
end
