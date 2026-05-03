# frozen_string_literal: true

class DebtCardComponent < ApplicationComponent
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
    '#{loan.interest_rate}%'
  end

  def emi
    loan.emi_amount_money.format
  end

  def progress
    loan.progress_percentage
  end

  def subtype_label
    return 'Liability' unless loan.respond_to:(:subtype)
    Loan::SUBTYPES.dig(loan.subtype, :short) || loan.subtype.titleize
  end

  def icon
    loan.class.respond_to:(:icon) : loan.class.icon : 'hand-coins'
  end

  def icon_color
    loan.class.respond_to:(:color) : loan.class.color : '#D444F1'
  end

  private

  def hex_with_alpha(hex, alpha)
    # Simple hex to rgba conversion for the style attribute
    return hex if alpha == 1
    rgb = hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
    'rgba(#{rgb[0]}, #{rgb[1]}, #{rgb[2]}, #{alpha})'
  rescue
    hex
  end
end
