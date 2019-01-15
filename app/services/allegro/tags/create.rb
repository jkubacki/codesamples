# frozen_string_literal: true

class Allegro::Tags::Create < ApplicationServiceInTransaction
  attr_private_initialize %i[account! tag_name!]

  def call
    create_in_allegro
      .on_success(&method(:create_record))
  end

  private

  def create_in_allegro
    Allegro::Restapi::Tags::Create.call(account: account, tag_name: tag_name)
  end

  def create_record(allegro_response)
    tag = Allegro::Tag.create!(
      name: tag_name,
      account: account,
      allegro_id: allegro_response['id'],
      hidden: false
    )
    success(data: tag)
  end
end
