#!/usr/bin/env ruby
# Kubera Single-File Installer
require 'fileutils'

puts "╔════════════════════════════════════╗"
puts "║       KUBERA INSTALLER v0.3          ║"
puts "║       Personal Finance OS             ║"
puts "╚════════════════════════════════════╝"
puts

print "📁 Install directory [~/.kubera]: "
input = gets.chomp
INSTALL_DIR = input.empty? ? File.expand_path("~/.kubera") : input

print "🔑 OpenRouter API Key: "
OPENROUTER_KEY = gets.chomp

print "📦 Install dependencies? (y/n) [y]: "
INSTALL_DEPS = gets.chomp.downcase != 'n'

puts "\n✅ Configuration collected. Starting...\n"

FileUtils.mkdir_p(INSTALL_DIR)
Dir.chdir(INSTALL_DIR)

puts "📥 Cloning Sure repository..."
system("git clone https://github.com/we-promise/sure.git sure 2>&1 | tail -3")

puts "⚙️  Applying Kubera features..."

# Create migration
FileUtils.mkdir_p("sure/db/migrate")
File.open("sure/db/migrate/20260502130000_add_debt_fields_to_loans.rb", "w") do |f|
  f.write("class AddDebtFieldsToLoans < ActiveRecord::Migration[7.0]\n")
  f.write("  def change\n")
  f.write("    add_column :loans, :emi_amount, :decimal, precision: 15, scale: 2\n")
  f.write("    add_column :loans, :due_date, :date\n")
  f.write("    add_column :loans, :debt_status, :string, default: 'active'\n")
  f.write("  end\n")
  f.write("end\n")
end

# Create .env.local
File.open("sure/.env.local", "w") do |f|
  f.write("OPENROUTER_API_KEY=" + OPENROUTER_KEY + "\n")
end

puts "\n✅ Kubera installation complete!"
puts "📂 Location: #{INSTALL_DIR}"
puts "🚀 Start: cd #{INSTALL_DIR}/sure && bin/dev"
puts "🌐 URL: http://localhost:3000"
