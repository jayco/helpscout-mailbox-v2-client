# frozen_string_literal: true

require 'helpscout/mailbox/paths'
require 'helpscout/api/auth'

module Helpscout
  module Mailbox
    module V2
      module Client
        class Http
          include Helpscout::Mailbox::Paths

          attr_reader :token, :base_url

          VERSION = '0.1.0'

          def initialize(base_url: nil, client_id:, client_secret:)
            @base_url = base_url || 'https://api.helpscout.net'
            @token = Helpscout::Api::Auth::Token.new(client_id: client_id, client_secret: client_secret)
          end

          def request(method, path, params = nil)
            @token.refresh
            headers = { 'Authorization': @token.to_s }
            base_request(method, path, headers, params)
          end

          def json_request(method, path, body, params = nil)
            @token.refresh
            headers = { 'Authorization': @token.to_s, 'Content-Type': 'application/json; charset=UTF-8' }
            base_request(method, path, headers, params, body.to_json)
          end

          private

          def base_request(method, path, headers, params = nil, body = nil)
            uri = build_uri(path, params)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.send_request(method, uri, body, headers)
          end

          def build_uri(path, params)
            uri = URI("#{@base_url}#{path}")
            uri.query = URI.encode_www_form(params) if params
            uri
          end
        end
      end
    end
  end
end
