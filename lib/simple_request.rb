# frozen_string_literal: true

require_relative "simple_request/version"

require "net/http"
require "json"
require "debug"
require_relative "get"
require_relative "post"

module SimpleRequest
  class Error < StandardError; end

  def self.get(url, params = {})
    Get.new(url, params).call
  end

  def self.post(url, params = {})
    Post.new(url, params).call
  end
end
