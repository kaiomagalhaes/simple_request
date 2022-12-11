# frozen_string_literal: true

require_relative "request"

class Get < Request
  def call!
    request = Net::HTTP::Get.new(uri.request_uri)

    add_json_content_type!(request)
    add_authorization_header!(request)

    respond(http, request)
  end
end
