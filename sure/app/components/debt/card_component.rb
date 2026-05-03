# frozen_string_literal: true

class Debt::CardComponent < ApplicationComponent
  attr_reader :loan

  def initialize(loan:)
    @loan = loan
  end

  def name
    loan.account.name
  end

  def balance
    loan.debt_remaining.format
  end

  def interest_rate
    "#{loan.interest_rate}%"
  end

  def emi
    loan.emi_amount_money.format
  end

  def progress
    loan.progress_percentage
  end

  def icon
    loan.class.icon
  end

  def icon_color
    loan.class.color
  end
end
