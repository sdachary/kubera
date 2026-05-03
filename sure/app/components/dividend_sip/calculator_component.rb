# frozen_string_literal: true

class DividendSip::CalculatorComponent < ApplicationComponent
  def initialize(monthly_investment:, target_income:)
    @monthly_investment = monthly_investment
    @target_income = target_income
  end
end
