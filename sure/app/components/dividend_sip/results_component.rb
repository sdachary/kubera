# frozen_string_literal: true

class DividendSip::ResultsComponent < ApplicationComponent
  def initialize(suggestions:, timeline:)
    @suggestions = suggestions
    @timeline = timeline
  end
end
