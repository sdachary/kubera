# Kubera Seeds — v2.0 Multi-Currency
#
# Run: bin/rails db:seed
# Idempotent: safe to run multiple times.

CURRENCIES = [
  { code: "INR", name: "Indian Rupee", symbol: "₹", decimal_places: 2 },
  { code: "USD", name: "US Dollar", symbol: "$", decimal_places: 2 },
  { code: "EUR", name: "Euro", symbol: "€", decimal_places: 2 },
  { code: "GBP", name: "British Pound", symbol: "£", decimal_places: 2 },
  { code: "JPY", name: "Japanese Yen", symbol: "¥", decimal_places: 0 },
  { code: "CNY", name: "Chinese Yuan", symbol: "¥", decimal_places: 2 },
  { code: "AUD", name: "Australian Dollar", symbol: "A$", decimal_places: 2 },
  { code: "CAD", name: "Canadian Dollar", symbol: "C$", decimal_places: 2 },
  { code: "CHF", name: "Swiss Franc", symbol: "Fr", decimal_places: 2 },
  { code: "SGD", name: "Singapore Dollar", symbol: "S$", decimal_places: 2 },
  { code: "HKD", name: "Hong Kong Dollar", symbol: "HK$", decimal_places: 2 },
  { code: "KRW", name: "South Korean Won", symbol: "₩", decimal_places: 0 },
  { code: "SEK", name: "Swedish Krona", symbol: "kr", decimal_places: 2 },
  { code: "NOK", name: "Norwegian Krone", symbol: "kr", decimal_places: 2 },
  { code: "DKK", name: "Danish Krone", symbol: "kr", decimal_places: 2 },
  { code: "NZD", name: "New Zealand Dollar", symbol: "NZ$", decimal_places: 2 },
  { code: "MXN", name: "Mexican Peso", symbol: "MX$", decimal_places: 2 },
  { code: "BRL", name: "Brazilian Real", symbol: "R$", decimal_places: 2 },
  { code: "ZAR", name: "South African Rand", symbol: "R", decimal_places: 2 },
  { code: "TRY", name: "Turkish Lira", symbol: "₺", decimal_places: 2 },
  { code: "RUB", name: "Russian Ruble", symbol: "₽", decimal_places: 2 },
  { code: "PLN", name: "Polish Zloty", symbol: "zł", decimal_places: 2 },
  { code: "THB", name: "Thai Baht", symbol: "฿", decimal_places: 2 },
  { code: "IDR", name: "Indonesian Rupiah", symbol: "Rp", decimal_places: 0 },
  { code: "MYR", name: "Malaysian Ringgit", symbol: "RM", decimal_places: 2 },
  { code: "PHP", name: "Philippine Peso", symbol: "₱", decimal_places: 2 },
  { code: "CZK", name: "Czech Koruna", symbol: "Kč", decimal_places: 2 },
  { code: "ILS", name: "Israeli Shekel", symbol: "₪", decimal_places: 2 },
  { code: "AED", name: "UAE Dirham", symbol: "د.إ", decimal_places: 2 },
  { code: "SAR", name: "Saudi Riyal", symbol: "﷼", decimal_places: 2 },
  { code: "NGN", name: "Nigerian Naira", symbol: "₦", decimal_places: 2 },
  { code: "KES", name: "Kenyan Shilling", symbol: "KSh", decimal_places: 2 }
].freeze

puts "🌍 Seeding currencies..."
CURRENCIES.each do |attrs|
  Currency.find_or_create_by!(code: attrs[:code]) do |c|
    c.name = attrs[:name]
    c.symbol = attrs[:symbol]
    c.decimal_places = attrs[:decimal_places]
  end
end
puts "✅ #{Currency.count} currencies seeded."

# Update existing users to have a valid currency reference
puts "👤 Updating existing users..."
User.find_each do |user|
  unless Currency.exists?(code: user.currency)
    user.update_column(:currency, "INR")
  end
  unless Currency.exists?(code: user.currency)
    user.update_column(:currency, "USD")
  end
end
puts "✅ Users updated."

# Seed budget categories for existing users
puts "📂 Seeding budget categories..."
User.find_each do |user|
  BudgetCategory.seed_for(user)
end
puts "✅ #{BudgetCategory.count} budget categories seeded."
