# frozen_string_literal: true

require_relative "simple_request/version"

require "net/http"
require "json"
require "debug"
require_relative "get"

module SimpleRequest
  class Error < StandardError; end

  def self.get(url, params = {})
    Get.new(url, params).call
  end
end
