class AddStorageBackendToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :storage_backend, :string, default: "local", null: false
  end
end
