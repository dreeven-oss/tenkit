# frozen_string_literal: true

require "jwt"
require "openssl"

module Tenkit
  class Authentication
    JWT_ALGORITHM = "ES256"

    class << self
      def new_token(expires_in: nil)
        JWT.encode(payload(expires_in), key, JWT_ALGORITHM, header)
      end

      private

      def header
        {
          alg: JWT_ALGORITHM,
          kid: Tenkit.config.key_id,
          id: "#{Tenkit.config.team_id}.#{Tenkit.config.service_id}"
        }
      end

      def payload(expires_in)
        issued_at = Time.new.to_i
        expires_in ||= 600

        {
          iss: Tenkit.config.team_id,
          iat: issued_at,
          exp: issued_at + expires_in,
          sub: Tenkit.config.service_id
        }
      end

      def key
        OpenSSL::PKey.read Tenkit.config.key
      end
    end
  end
end
