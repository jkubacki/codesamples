# frozen_string_literal: true

class Allegro::Tags::Delete < ApplicationService
  attr_private_initialize %i[tag!]

  def call
    delete_record
      .on_success(&method(:delete_in_allegro))
  end

  private

  def delete_record
    tag.destroy!
    success
  end

  def delete_in_allegro
    Allegro::Restapi::Tags::Delete.call(tag: tag)
  end
end
