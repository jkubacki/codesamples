# frozen_string_literal: true

class Allegro::Restapi::Client
  def initialize(account:)
    @account = account
  end

  def get(endpoint:, params: {})
    call(method: :get, endpoint: endpoint, params: params)
  end

  def post(endpoint:, params: {})
    call(method: :post, endpoint: endpoint, params: params)
  end

  def put(endpoint:, params: {})
    call(method: :put, endpoint: endpoint, params: params)
  end

  def delete(endpoint:, params: {})
    call(method: :delete, endpoint: endpoint, params: params)
  end

  private

  attr_reader :account

  def call(method:, endpoint:, params: {})
    refresh_restapi_token
    httparty_response =
      HTTParty.public_send(
        method,
        "#{base_url}/#{endpoint}",
        { body: params.to_json }.merge(headers: authorization_headers)
      )
    handle_invalid_token_response(httparty_response)
    Allegro::Restapi::Response.new(httparty_response: httparty_response)
  end

  def base_url
    account.restapi_site
  end

  def authorization_headers
    {
      'Authorization' => "Bearer #{account.token}",
      'Api-key' => account.restapi_key,
      'Accept' => 'application/vnd.allegro.public.v1+json;charset=UTF-8',
      'Content-Type' => 'application/vnd.allegro.public.v1+json',
      'accept-language' => 'PL'
    }
  end

  def handle_invalid_token_response(response)
    Allegro::Restapi::Tokens::HandleInvalidTokenResponse.call(response: response, account: account)
  end

  def refresh_restapi_token
    account.refresh_restapi_token
  end
end
