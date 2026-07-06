class StorageProvider
  UnsupportedError = Class.new(StandardError)
  NotConnectedError = Class.new(StandardError)

  SUPPORTED_TYPES = %i[
    transactions debts portfolios investments
    budgets budget_categories recurring_expenses
    net_worth_snapshots trips trip_expenses
  ].freeze

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def name
    raise NotImplementedError
  end

  def connected?
    raise NotImplementedError
  end

  SUPPORTED_TYPES.each do |type|
    define_method("list_#{type}") do |filters: {}|
      raise NotImplementedError
    end

    define_method("get_#{type.to_s.singularize}") do |id:|
      raise NotImplementedError
    end

    define_method("create_#{type.to_s.singularize}") do |attrs:|
      raise NotImplementedError
    end

    define_method("update_#{type.to_s.singularize}") do |id:, attrs:|
      raise NotImplementedError
    end

    define_method("delete_#{type.to_s.singularize}") do |id:|
      raise NotImplementedError
    end
  end

  def self.for(user)
    case user.storage_backend
    when "google_sheets" then StorageProvider::GoogleSheets.new(user)
    else StorageProvider::LocalDatabase.new(user)
    end
  end

  def migrate_to(new_backend)
    target = new_backend.new(user)
    SUPPORTED_TYPES.each do |type|
      records = send("list_#{type}")
      records.each do |record|
        target.send("create_#{type.to_s.singularize}", attrs: record)
      end
    end
    user.update!(storage_backend: target.class.name.demodulize.underscore)
  end
end
