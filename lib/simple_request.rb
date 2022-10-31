# frozen_string_literal: true

require_relative "simple_request/version"

require "net/http"
require "json"
require_relative "get"
require_relative "post"

module SimpleRequest
  class Error < StandardError; end

  def self.get(url, configuration = {})
    Get.new(url, configuration).call
  end

  def self.post(url, configuration = {})
    Post.new(url, configuration).call
  end
end
