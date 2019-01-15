# frozen_string_literal: true

class Allegro::Tags::Accounts::Sync < ApplicationServiceInTransaction
  attr_private_initialize %i[account!]

  def call
    create_missing_tags
      .on_success(&method(:delete_not_matching_tags))
  end

  private

  def create_missing_tags
    missing_tag_names.each do |tag_name|
      result = Allegro::Tags::Create.call(account: account, tag_name: tag_name)
      return result if result.failure?
    end
    success
  end

  def delete_not_matching_tags
    not_matching_tags.each do |tag|
      result = Allegro::Tags::Delete.call(tag: tag)
      return result if result.failure?
    end
    success
  end

  def not_matching_tags
    not_matching_tag_names = allegro_tag_names - combine_tag_names
    return [] if not_matching_tag_names.empty?

    Allegro::Tag.where(account: account, name: not_matching_tag_names)
  end

  def missing_tag_names
    combine_tag_names - allegro_tag_names
  end

  def combine_tag_names
    Allegro::Tags::AllQuery.call
  end

  def allegro_tag_names
    Allegro::Tag.where(account: account).pluck(:name)
  end
end
