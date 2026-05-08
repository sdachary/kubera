class AddArgon2ToApiKeys < ActiveRecord::Migration[7.2]
  def up
    add_column :api_keys, :token_digest, :string unless column_exists?(:api_keys, :token_digest)
    add_column :api_keys, :raw_token, :string unless column_exists?(:api_keys, :raw_token)

    add_index :api_keys, :token_digest, unique: true, where: "token_digest IS NOT NULL",
      name: "idx_api_keys_on_token_digest_unique" unless index_exists?(:api_keys, :token_digest)

    say "Migration complete. Existing keys will be rehashed on next authentication."
  end

  def down
    remove_column :api_keys, :token_digest if column_exists?(:api_keys, :token_digest)
    remove_column :api_keys, :raw_token if column_exists?(:api_keys, :raw_token)
  end
end
