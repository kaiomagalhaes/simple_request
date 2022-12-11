# frozen_string_literal: true

require_relative "request"

class Patch < Request
  def call!
    request = Net::HTTP::Patch.new(uri.path)

    add_json_content_type!(request)
    add_authorization_header!(request)
    add_body!(request)

    respond(http, request)
  end

  def body
    @body ||= configuration[:body]
  end

  def add_body!(request)
    request.body = body.to_json if body
  end
end
