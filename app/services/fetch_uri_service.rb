# frozen_string_literal: true

require 'http'

class FetchUri < ApplicationService
  param :url, Types::Url
  option :basic_auth, Types::Hash.schema(user: Types::Strict::String, pass: Types::Strict::String), optional: true
  option :auth, Types::String, optional: true
  option :type, Types::Symbol.enum(:get, :post), default: -> { :get }
  option :params, Types::Hash.schema(
    params?: Types::Hash,
    form?: Types::Hash,
    body?: Types::String,
    json?: Types::Hash
  ), default: -> { {} }
  option :headers, Types::Hash, default: -> { {} }

  class Error < StandardError
    attr_reader :response
    def initialize(response)
      @response = response
    end

    def message
      "Request failed - #{response.status}: #{response.body}"
    end
  end

  def call
    start_time = Time.now

    client = HTTP.follow.accept(:json).headers(headers)

    client = client.basic_auth(user: basic_auth[:user], pass: basic_auth[:pass]) if basic_auth
    client = client.auth("Bearer #{auth}") if auth

    response = client.public_send(type, url, params)

    raise Error.new(response) unless response.status.success?

    response
  rescue HTTP::ConnectionError, HTTP::TimeoutError => exception
    if ::Application.env == 'production'
      Sentry.set_extras(
        fetch_api: {
          http: {
            response_code: response&.code,
            response_headers: response&.headers.to_h,
            execution_time: Time.now - start_time
          }
        }
      )
    end

    raise exception, "Request failed - #{exception.message}"
  end
end
