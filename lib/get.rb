# frozen_string_literal: true

require_relative "request"

class Get < Request
  def call
    uri = URI.parse(clean_url(@url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = use_ssl?(@url)
    req = Net::HTTP::Get.new(uri.request_uri)

    add_authorization_header!(req)

    respond(http, req)
  end
end
