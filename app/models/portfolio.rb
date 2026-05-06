class Portfolio < ApplicationRecord
  has_many :holdings
  has_many :dividend_sips
end
