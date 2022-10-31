# frozen_string_literal: true

require_relative "simple_request/version"

require "net/http"
require "json"
require "debug"

module SimpleRequest
  class Error < StandardError; end

  DEFAULT_PARAMS = {
    expect: :json
  }.freeze

  def self.get(url, params = {})
    configuration = DEFAULT_PARAMS.merge(params)

    uri = URI.parse(clean_url(url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = use_ssl?(url)
    req = Net::HTTP::Get.new(uri.request_uri)

    req["Authorization"] = configuration[:authorization] if configuration[:authorization]

    response = http.request(req)

    respond(response, configuration)
  end

  def self.respond(response, configuration)
    case configuration[:expect]
    when :json
      JSON.parse(response.body)
    when :html
      response.body
    when :full
      response
    end
  end

  def self.use_ssl?(url)
    url.match?(/^https/)
  end

  def self.clean_url(url)
    url.gsub(" ", "%20")
  end
end
