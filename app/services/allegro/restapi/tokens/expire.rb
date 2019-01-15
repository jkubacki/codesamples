# frozen_string_literal: true

class Allegro::Restapi::Tokens::Expire < ApplicationService
  attr_private_initialize(%i[account!])

  def call
    account.update!(expires_at: Time.current)
    success
  end
end
