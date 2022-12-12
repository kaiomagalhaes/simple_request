# frozen_string_literal: true

require "debug"
class Request
  DEFAULT_PARAMS = {
    expect: :json, # :json, :html, fullo
    retry: {
      times: 1,
      valid_codes: []
    }
  }.freeze

  def initialize(url, params)
    @url = url
    @params = params
  end

  def call
    retries = configuration.dig(:retry, :times)
    valid_codes = configuration.dig(:retry, :valid_codes)
    response = nil

    (1..retries).each do |number|
      http, request = call!
      res = http.request(request)
      response = respond(res)
      puts number

      if valid_codes.any?
        code = res.code.to_i
        in_code = valid_codes.map(&:to_i).index(code)
        break if in_code
      else
        break
      end
    rescue StandardError => e
      response = e
    end

    response
  end

  def json?
    configuration[:expect] == :json
  end

  def add_json_content_type!(request)
    request.content_type = "application/json" if json?
  end

  def http
    return @http if @http

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = use_ssl?
    http
  end

  def uri
    @uri ||= URI.parse(clean_url)
  end

  def configuration
    @configuration ||= DEFAULT_PARAMS.merge(@params) do |_k, old, new|
      old.instance_of?(Hash) && new.instance_of?(Hash) ? old.merge(new) : new
    end
  end

  def respond(response)
    case configuration[:expect]
    when :json
      JSON.parse(response.body)
    when :html
      response.body
    when :full
      response
    end
  end

  def use_ssl?
    @url.match?(/^https/)
  end

  def clean_url
    @url.gsub(" ", "%20")
  end

  def add_authorization_header!(req)
    req["Authorization"] = configuration[:authorization] if configuration[:authorization]
  end
end
