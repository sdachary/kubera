#!/usr/bin/env ruby
# Kubera Single-File Installer with Modern Theme
require 'fileutils'

# Color theme from docs/assets
class Theme
  PRIMARY = "\e[38;2;29;158;117m"  # #1d9e75
  ACCENT = "\e[38;2;216;90;48m"   # #d85a30
  RESET = "\e[0m"
  BOLD = "\e[1m"
  DIM = "\e[2m"

  def self.box_top
    "#{PRIMARY}╔══════════════════════════════════════╗#{RESET}"
  end

  def self.box_bottom
    "#{PRIMARY}╚══════════════════════════════════════╝#{RESET}"
  end

  def self.box_content(text)
    "#{PRIMARY}║#{RESET} #{BOLD}#{text.center(36)}#{RESET} #{PRIMARY}║#{RESET}"
  end
end

puts Theme.box_top
puts Theme.box_content("KUBERA INSTALLER v0.3")
puts Theme.box_content("Personal Finance OS")
puts Theme.box_bottom
puts

print "📁 Install directory [~/.kubera]: "
input = gets.chomp
INSTALL_DIR = input.empty? ? File.expand_path("~/.kubera") : input

print "🔑 OpenRouter API Key: "
OPENROUTER_KEY = gets.chomp

print "📦 Install dependencies? (y/n) [y]: "
INSTALL_DEPS = gets.chomp.downcase != 'n'

print "🧪 Run tests? (y/n) [n]: "
RUN_TESTS = gets.chomp.downcase == 'y'

puts "\n#{Theme::DIM}✅ Configuration collected. Starting...#{Theme::RESET}\n"

FileUtils.mkdir_p(INSTALL_DIR)
Dir.chdir(INSTALL_DIR)

puts "📥 Cloning Sure repository..."
system("git clone https://github.com/we-promise/sure.git sure 2>&1 | tail -3")

puts "⚙️  Applying Kubera v0.2 Debt Payoff Module..."

FileUtils.mkdir_p("sure/db/migrate")
File.write("sure/db/migrate/20260502130000_add_debt_fields_to_loans.rb", <<~RUBY)
  class AddDebtFieldsToLoans < ActiveRecord::Migration[7.0]
    def change
      add_column :loans, :emi_amount, :decimal, precision: 15, scale: 2
      add_column :loans, :due_date, :date
      add_column :loans, :debt_status, :string, default: "active"
    end
  end
