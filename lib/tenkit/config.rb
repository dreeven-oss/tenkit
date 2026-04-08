# frozen_string_literal: true

module Tenkit
  class Config
    attr_accessor :team_id, :service_id, :key_id, :key

    REQUIRED_ATTRIBUTES = %i[
      @team_id
      @service_id
      @key_id
      @key
    ].freeze

    def validate!
      missing_required = REQUIRED_ATTRIBUTES.filter { |required| instance_variable_get(required).nil? }
      return unless missing_required.length.positive?

      raise TenkitError,
        "#{missing_required.join(", ")} cannot be blank. check that you have configured your credentials"
    end
  end
end
