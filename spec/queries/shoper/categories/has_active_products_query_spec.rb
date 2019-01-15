# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shoper::Categories::HasActiveProductsQuery do
  subject do
    described_class.call(shoper_category: shoper_category)
  end

  let(:shoper_category) do
    create(:shoper_category, redbox_category: redbox_category, account: account)
  end
  let(:redbox_category) { create(:redbox_category) }
  let(:account) { create(:shoper_account) }

  context 'without subcategories' do
    context 'without product categories' do
      it { is_expected.to eq false }
    end

    context 'with product categories' do
      let!(:shoper_product) { create(:shoper_product, active: active) }

      before do
        create(:shoper_product_category, product: shoper_product, category: shoper_category)
      end

      context 'when product not active' do
        let(:active) { false }

        it { is_expected.to eq false }
      end

      context 'when product active' do
        let(:active) { true }

        it { is_expected.to eq true }
      end
    end
  end

  context 'with subcategories' do
    let!(:subcategory) do
      create(:shoper_category, redbox_category: redbox_subcategory, account: account)
    end

    let(:redbox_subcategory) { create(:redbox_category, category_id: redbox_category.id + '123') }

    context 'without product categories for subcategory' do
      it { is_expected.to eq false }
    end

    context 'with product categories for subcategory' do
      let!(:shoper_product) { create(:shoper_product, active: active) }

      before do
        create(:shoper_product_category, product: shoper_product, category: subcategory)
      end

      context 'when product not active' do
        let(:active) { false }

        it { is_expected.to eq false }
      end

      context 'when product active' do
        let(:active) { true }

        it { is_expected.to eq true }
      end
    end
  end
end
