# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packaging::Inpost::SectionsController do
  describe 'GET index' do
    subject { get :index }

    let(:user) { create(:user) }
    let(:sections) { double }

    before do
      sign_in user
      allow(Packaging::Inpost::SectionsQuery).to receive(:call).and_return(sections)
    end

    include_context 'authorized', Packaging::Inpost::SectionsControllerPolicy, :index?

    it 'fetches sections for inpost packaging' do
      expect(Packaging::Inpost::SectionsQuery).to receive(:call).once
      subject
    end

    it 'renders index with sections' do
      subject
      expect(response).to render_template(:index, locals: { sections: sections })
    end
  end
end
