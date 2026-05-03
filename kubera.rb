#!/usr/bin/env ruby
# Kubera Single-File Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/sdachary/kubera/main/kubera.rb | ruby

require 'fileutils'
require 'tempfile'

puts "╔══════════════════════════════════════╗"
puts "║       KUBERA INSTALLER v0.3          ║"
puts "╚══════════════════════════════════════╝"
puts

# Collect all details upfront
print "📁 Install directory [~/.kubera]: "
input = gets.chomp
INSTALL_DIR = input.empty? ? File.expand_path("~/.kubera") : input

print "🔑 OpenRouter API Key (for AI suggestions): "
OPENROUTER_KEY = gets.chomp

print "🎨 Install dependencies? (y/n) [y]: "
INSTALL_DEPS = gets.chomp.downcase != 'n'

print "🧪 Run tests after install? (y/n) [n]: "
RUN_TESTS = gets.chomp.downcase == 'y'

puts "\n✅ Configuration collected. Starting installation...\n"

# Step 1: Create install directory
FileUtils.mkdir_p(INSTALL_DIR)
Dir.chdir(INSTALL_DIR)

# Step 2: Clone Sure repo as sure/
puts "📥 Cloning Sure repository..."
system("git clone https://github.com/we-promise/sure.git sure 2>&1 | tail -3")

# Step 3: Apply Kubera modifications to sure/
puts "⚙️  Applying Kubera v0.2 Debt Payoff Module..."

# Create migration
File.write("sure/db/migrate/20260502130000_add_debt_fields_to_loans.rb", <<~RUBY)
  class AddDebtFieldsToLoans < ActiveRecord::Migration[7.0]
    def change
      add_column :loans, :emi_amount, :decimal, precision: 15, scale: 2
      add_column :loans, :due_date, :date
      add_column :loans, :debt_status, :string, default: 'active'
    end
  end
RUBY

# Create DebtPayoffCalculator
FileUtils.mkdir_p("sure/app/services")
File.write("sure/app/services/debt_payoff_calculator.rb", <<~RUBY)
  class DebtPayoffCalculator
    attr_reader :debts, :extra_payment

    def initialize(debts, extra_payment = 0)
      @debts = debts
      @extra_payment = extra_payment.to_f
    end

    def avalanche_method
      sorted = @debts.sort_by { |d| -d.interest_rate.to_f }
      calculate_payoff_schedule(sorted)
    end

    def snowball_method
      sorted = @debts.sort_by { |d| d.account.balance }
      calculate_payoff_schedule(sorted)
    end

    def debt_free_date(method = :avalanche)
      schedule = method == :avalanche ? avalanche_method : snowball_method
      schedule[:payoff_date]
    end

    def total_interest_paid(method = :avalanche)
      schedule = method == :avalanche ? avalanche_method : snowball_method
      schedule[:total_interest]
    end

    def payoff_simulation(debt_id, extra_monthly_payment)
      debt = @debts.find { |d| d.id == debt_id }
      return nil unless debt
      simulate_single_debt(debt, extra_monthly_payment)
    end

    private

    def calculate_payoff_schedule(sorted)
      total_months = 0
      total_interest = 0
      remaining_extra = @extra_payment
      schedule = []

      sorted.each do |debt|
        months, interest = calculate_debt_payoff(debt, remaining_extra)
        total_months += months
        total_interest += interest
        remaining_extra = [remaining_extra - debt.emi_amount.to_f, 0].max

        schedule << {
          debt: debt,
          months_to_payoff: months,
          interest_paid: interest,
          payoff_date: Date.today >> total_months
        }
      end

      {
        schedule: schedule,
        total_months: total_months,
        total_interest: total_interest,
        payoff_date: Date.today >> total_months
      }
    end

    def calculate_debt_payoff(debt, extra_payment = 0)
      balance = debt.account.balance
      rate = debt.interest_rate.to_f / 100 / 12
      emi = debt.emi_amount.to_f + extra_payment.to_f
      months = 0
      total_interest = 0

      while balance > 0 && months < 1200
        interest = balance * rate
        total_interest += interest
        principal = emi - interest
        balance -= principal
        months += 1
      end

      [months, total_interest]
    end

    def simulate_single_debt(debt, extra_monthly)
      balance = debt.account.balance
      rate = debt.interest_rate.to_f / 100 / 12
      emi = debt.emi_amount.to_f + extra_monthly.to_f
      months = 0

      while balance > 0 && months < 1200
        interest = balance * rate
        principal = emi - interest
        balance -= principal
        months += 1
      end

      {
        debt: debt,
        original_payoff_months: calculate_debt_payoff(debt, 0)[0],
        new_payoff_months: months,
        months_saved: calculate_debt_payoff(debt, 0)[0] - months,
        new_payoff_date: Date.today >> months
      }
    end
  end
RUBY

# Create DividendScreener for v0.3
File.write("sure/app/services/dividend_screener.rb", <<~RUBY)
  class DividendScreener
    def initialize(monthly_investment:, target_income:)
      @monthly_investment = monthly_investment.to_f
      @target_income = target_income.to_f
    end

    def suggest_stocks
      [
        { symbol: "INFY", name: "Infosys", dividend_yield: 2.5, risk: "low" },
        { symbol: "TCS", name: "Tata Consultancy", dividend_yield: 1.8, risk: "low" }
      ]
    end

    def calculate_sip_timeline
      months_needed = (@target_income * 12) / (@monthly_investment * 0.02)
      {
        months: months_needed.ceil,
        projected_income: @monthly_investment * months_needed * 0.02 / 12
      }
    end
  end
RUBY

# Update .env.local
env_content = <<~ENV
  OPENROUTER_API_KEY=#{OPENROUTER_KEY}
  SUPABASE_URL=#{SUPABASE_URL}
  SUPABASE_KEY=#{SUPABASE_KEY}
  DATABASE_URL=postgresql://localhost/kubera_development
ENV
File.write("sure/.env.local", env_content)

puts "✅ Kubera v0.2 + v0.3 features installed!"

# Step 4: Install dependencies
if INSTALL_FRONTEND
  puts "\n📦 Installing dependencies..."
  system("cd #{INSTALL_DIR}/sure && bundle install 2>&1 | tail -5")
  system("cd #{INSTALL_DIR}/sure && npm install 2>&1 | tail -5")
end

# Step 5: Run tests
if RUN_TESTS
  puts "\n🧪 Running tests..."
  system("cd #{INSTALL_DIR}/sure && bin/rails test 2>&1 | tail -10")
end

puts "\n🎉 Installation complete!"
puts "📂 Location: #{INSTALL_DIR}"
puts "🚀 Start with: cd #{INSTALL_DIR}/sure && bin/dev"
puts "🌐 URL: http://localhost:3000"
