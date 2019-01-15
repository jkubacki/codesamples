# frozen_string_literal: true

class Allegro::Restapi::Tokens::HandleInvalidTokenResponse < ApplicationService
  attr_private_initialize(%i[response! account!])

  def call
    invalid_token_response? ? expire_token : success
  end

  private

  def expire_token
    Allegro::Restapi::Tokens::ExpireJob.perform_async(account.id)
  end

  def invalid_token_response?
    response.code == 401 && response.parsed_response['error'] == 'invalid_token'
  end
end
