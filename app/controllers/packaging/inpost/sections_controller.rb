# frozen_string_literal: true

class Packaging::Inpost::SectionsController < ApplicationController
  def index
    sections = Packaging::Inpost::SectionsQuery.call
    render :index, locals: { sections: sections }
  end
end
