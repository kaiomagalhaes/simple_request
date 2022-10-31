# frozen_string_literal: true

class Request
  DEFAULT_PARAMS = {
    expect: :json # :json, :html, full
  }.freeze

  def initialize(url, params)
    @url = url
    @params = params
  end

  def configuration
    @configuration ||= DEFAULT_PARAMS.merge(@params)
  end

  def respond(http, req)
    response = http.request(req)

    case configuration[:expect]
    when :json
      JSON.parse(response.body)
    when :html
      response.body
    when :full
      response
    end
  end

  def use_ssl?(url)
    url.match?(/^https/)
  end

  def clean_url(url)
    url.gsub(" ", "%20")
  end

  def add_authorization_header!(req)
    req["Authorization"] = configuration[:authorization] if configuration[:authorization]
  end
end
