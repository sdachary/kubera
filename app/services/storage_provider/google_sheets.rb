class StorageProvider::GoogleSheets < StorageProvider
  SPREADSHEET_TITLE = "Kubera — Financial Data"

  TAB_CONFIG = {
    transactions: {
      tab_name: "Transactions",
      headers: %w[id description amount currency_code transaction_date transaction_type merchant notes budget_category_id recurring recurring_frequency created_at updated_at]
    },
    debts: {
      tab_name: "Debts",
      headers: %w[id name category amount interest_rate emi_amount paid_amount status currency_code started_at due_date notes created_at updated_at]
    },
    portfolios: {
      tab_name: "Portfolios",
      headers: %w[id name goal risk_tolerance currency_code total_value current_allocation created_at updated_at]
    },
    investments: {
      tab_name: "Investments",
      headers: %w[id portfolio_id symbol name investment_type shares buy_price current_price dividend_yield sector currency_code notes created_at updated_at]
    },
    budgets: {
      tab_name: "Budgets",
      headers: %w[id budget_category_id monthly_limit currency_code period start_date end_date notes created_at updated_at]
    },
    budget_categories: {
      tab_name: "Budget Categories",
      headers: %w[id name icon color sort_order active created_at updated_at]
    },
    recurring_expenses: {
      tab_name: "Recurring Expenses",
      headers: %w[id name amount currency_code frequency category next_due_date auto_debit active notes created_at updated_at]
    },
    net_worth_snapshots: {
      tab_name: "Net Worth",
      headers: %w[id snapshot_date total_assets total_liabilities net_worth currency_code breakdown created_at updated_at]
    },
    trips: {
      tab_name: "Trips",
      headers: %w[id name destination start_date end_date currency group_type status total_budget notes created_at updated_at]
    },
    trip_expenses: {
      tab_name: "Trip Expenses",
      headers: %w[id trip_id trip_member_id trip_category_id amount description expense_date split_type split_details created_at updated_at]
    }
  }.freeze

  def initialize(user)
    super
    sheets_service = GoogleAuthService.new(user).sheets_service
    drive_service = GoogleAuthService.new(user).drive_service
    @sheets = sheets_service
    @drive = drive_service
    @spreadsheet_id = find_or_create_spreadsheet
  end

  def name
    "google_sheets"
  end

  def connected?
    user.refresh_token.present? && @spreadsheet_id.present?
  rescue
    false
  end

  TAB_CONFIG.each do |type, config|
    define_method("list_#{type}") do |filters: {}|
      rows = read_tab(config[:tab_name])
      objects = rows_to_objects(config[:headers], rows)
      apply_filters(objects, filters)
    end

    define_method("get_#{type.to_s.singularize}") do |id:|
      rows = read_tab(config[:tab_name])
      objects = rows_to_objects(config[:headers], rows)
      objects.find { |o| o["id"] == id } || raise(ActiveRecord::RecordNotFound, "#{type} not found")
    end

    define_method("create_#{type.to_s.singularize}") do |attrs:|
      rows = read_tab(config[:tab_name])
      now = Time.current.iso8601
      data = config[:headers].each_with_object({}) do |h, obj|
        obj[h] = case h
                 when "id" then SecureRandom.uuid
                 when "created_at", "updated_at" then now
                 else attrs[h] || attrs[h.to_sym]
                 end
      end
      rows << config[:headers].map { |h| serialize_value(data[h]) }
      write_tab(config[:tab_name], rows)
      SheetRecord.new(data)
    end

    define_method("update_#{type.to_s.singularize}") do |id:, attrs:|
      rows = read_tab(config[:tab_name])
      objects = rows_to_objects(config[:headers], rows)
      idx = objects.index { |o| o["id"] == id }
      raise(ActiveRecord::RecordNotFound, "#{type} not found") unless idx

      attrs.each do |key, value|
        objects[idx][key.to_s] = value
      end
      objects[idx]["updated_at"] = Time.current.iso8601

      rows[1..] = objects.map { |o| config[:headers].map { |h| serialize_value(o[h]) } }
      write_tab(config[:tab_name], rows)
      objects[idx]
    end

    define_method("delete_#{type.to_s.singularize}") do |id:|
      rows = read_tab(config[:tab_name])
      objects = rows_to_objects(config[:headers], rows)
      idx = objects.index { |o| o["id"] == id }
      raise(ActiveRecord::RecordNotFound, "#{type} not found") unless idx

      rows.delete_at(idx + 1)
      write_tab(config[:tab_name], rows)
    end
  end

  private

  def find_or_create_spreadsheet
    response = @drive.list_files(
      q: "name='#{SPREADSHEET_TITLE}' and trashed=false",
      spaces: 'drive'
    )
    return response.files.first.id if response.files.any?

    spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(
      properties: Google::Apis::SheetsV4::SpreadsheetProperties.new(title: SPREADSHEET_TITLE)
    )
    result = @sheets.create_spreadsheet(spreadsheet)
    sid = result.spreadsheet_id
    create_all_tabs(sid)
    sid
  end

  def create_all_tabs(spreadsheet_id)
    requests = TAB_CONFIG.values.map do |config|
      {
        add_sheet: {
          properties: { title: config[:tab_name] }
        }
      }
    end
    request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: requests)
    @sheets.batch_update_spreadsheet(spreadsheet_id, request)
    TAB_CONFIG.each do |_type, config|
      range = "'#{config[:tab_name]}'!A1"
      value_range = Google::Apis::SheetsV4::ValueRange.new(values: [config[:headers]])
      @sheets.update_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: 'USER_ENTERED')
    end
  rescue Google::Apis::ClientError => e
    Rails.logger.warn "[GoogleSheets] Tab creation error: #{e.message}"
  end

  def read_tab(tab_name)
    range = "'#{tab_name}'!A1:ZZ"
    response = @sheets.get_spreadsheet_values(@spreadsheet_id, range)
    response.values || []
  rescue Google::Apis::ClientError => e
    Rails.logger.warn "[GoogleSheets] Read error for #{tab_name}: #{e.message}"
    []
  end

  def write_tab(tab_name, rows)
    return if rows.empty?
    range = "'#{tab_name}'!A1"
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: rows)
    @sheets.update_spreadsheet_value(@spreadsheet_id, range, value_range, value_input_option: 'USER_ENTERED')
  end

  def rows_to_objects(headers, rows)
    return [] if rows.length < 2
    rows[1..].map do |row|
      data = headers.each_with_index.each_with_object({}) do |(h, i), obj|
        obj[h] = row[i]
      end
      SheetRecord.new(data)
    end
  end

  def apply_filters(objects, filters)
    return objects if filters.blank?
    objects.select do |obj|
      filters.all? do |key, value|
        case value
        when nil then true
        when Array then value.include?(obj[key.to_s] || obj[key])
        else (obj[key.to_s] || obj[key]).to_s == value.to_s
        end
      end
    end
  end

  def serialize_value(value)
    case value
    when Hash, Array then value.to_json
    when BigDecimal then value.to_f.to_s
    when Time, DateTime, Date then value.iso8601
    else value.to_s
    end
  end

  class SheetRecord
    def initialize(data = {})
      @data = data
    end

    def [](key)
      @data[key.to_s]
    end

    def []=(key, value)
      @data[key.to_s] = value
    end

    def to_h
      @data.dup
    end

    def attributes
      @data
    end

    def method_missing(name, *args, &block)
      key = name.to_s
      if @data.key?(key)
        @data[key]
      elsif key.end_with?("=")
        @data[key.chomp("=")] = args.first
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      @data.key?(name.to_s) || name.to_s.end_with?("=") || super
    end
  end
end
