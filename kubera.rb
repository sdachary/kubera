#!/usr/bin/env ruby
# Kubera Single-File Installer
require 'fileutils'

puts "╔══════════════════════════════════════╗"
puts "║       KUBERA INSTALLER v0.3          ║"
puts "╚══════════════════════════════════════╝"
puts

print "Install directory [~/.kubera]: "
input = gets.chomp
INSTALL_DIR = input.empty? ? File.expand_path("~/.kubera") : input

print "OpenRouter API Key: "
OPENROUTER_KEY = gets.chomp

print "Install dependencies? (y/n) [y]: "
INSTALL_DEPS = gets.chomp.downcase != 'n'

puts "\nStarting installation..."
FileUtils.mkdir_p(INSTALL_DIR)
Dir.chdir(INSTALL_DIR)

puts "Cloning Sure repo..."
system("git clone https://github.com/we-promise/sure.git sure 2>&1 | tail -3")

puts "Applying Kubera features..."

# Create migration
FileUtils.mkdir_p("sure/db/migrate")
File.write("sure/db/migrate/20260502130000_add_debt_fields_to_loans.rb", <<~RUBY2)
  class AddDebtFieldsToLoans < ActiveRecord::Migration[7.0]
    def change
      add_column :loans, :emi_amount, :decimal, precision: 15, scale: 2
      add_column :loans, :due_date, :date
      add_column :loans, :debt_status, :string, default: "active"
    end
  end
RUBY2

# Create DebtPayoffCalculator
FileUtils.mkdir_p("sure/app/services")
File.write("sure/app/services/debt_payoff_calculator.rb", <<~RUBY2)
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
        schedule << { debt: debt, months_to_payoff: months, interest_paid: interest, payoff_date: Date.today >> total_months }
      end

      { schedule: schedule, total_months: total_months, total_interest: total_interest, payoff_date: Date.today >> total_months }
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
  end
RUBY2

# Create .env.local
File.write("sure/.env.local", "OPENROUTER_API_KEY=#{OPENROUTER_KEY}\n")

puts "\nInstallation complete!"
puts "Location: #{INSTALL_DIR}"
puts "Start: cd #{INSTALL_DIR}/sure && bin/dev"
