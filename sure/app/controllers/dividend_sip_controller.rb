# frozen_string_literal: true

class DividendSipController < ApplicationController
  def index
    # Initial state for the UI
    @monthly_investment = 5000
    @target_income = 1000
  end
end
