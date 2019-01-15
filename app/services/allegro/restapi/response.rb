# frozen_string_literal: true

class Allegro::Restapi::Response
  extend Memoizer::Helper

  attr_reader :httparty_response

  delegate :success?, to: :httparty_response

  def initialize(httparty_response:)
    @httparty_response ||= httparty_response
  end

  memoize :body
  def body
    JSON.parse(httparty_response.body)
  rescue JSON::ParserError => _error
    httparty_response.body
  end

  def result
    if success?
      Result::Success.new(data: body)
    else
      Result::Failure.new(data: body)
    end
  end

  def failure?
    !success?
  end
end
