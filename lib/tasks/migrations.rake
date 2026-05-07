namespace :db do
  desc "Squash all migrations into a single initialization migration"
  task squash_migrations: :environment do
    squashed_version = Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename = "db/migrate/#{squashed_version}_squashed_migration.rb"

    schema = File.read(Rails.root.join("db/schema.rb"))
    tables = schema.scan(/create_table.*?end$/m)

    migration_code = <<~RUBY
      class SquashedMigration < ActiveRecord::Migration[7.2]
        def up
          # This migration replaces all previous migrations.
          # Generated from db/schema.rb at #{Time.now.iso8601}
          # Previous migration count: #{Dir[Rails.root.join("db/migrate/*.rb")].count}

          #{tables.map { |t| t.split("\n").map { |line| "    #{line}" }.join("\n") }.join("\n\n")}
        end

        def down
          # To reverse, drop all tables in reverse order
          #{schema.scan(/create_table "(\w+)"/).reverse.map { |name| "    drop_table :#{name[0]}" }.join("\n")}
        end
      end
    RUBY

    File.write(Rails.root.join(filename), migration_code)
    puts "Created squashed migration: #{filename}"
    puts "Run `rails db:migrate` to apply (ensure schema is current first)"
  end
end
