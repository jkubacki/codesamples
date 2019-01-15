# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Tags::Products::ShouldUpdate do
  subject do
    described_class.call(
      product_after_update: product_after_update,
      before_style_ids: before_style_ids,
      before_ocassion_ids: before_ocassion_ids
    )
  end

  let(:product_after_update) { build_stubbed(:redbox_product) }
  let(:before_style_ids) { [1, 2] }
  let(:before_ocassion_ids) { [1, 2] }

  before do
    allow(product_after_update).to receive(:style_ids).and_return(after_style_ids)
    allow(product_after_update).to receive(:ocassion_ids).and_return(after_ocassion_ids)
  end

  context 'when before style ids and ocassion ids the same as in product after update' do
    let(:after_style_ids) { before_style_ids }
    let(:after_ocassion_ids) { before_ocassion_ids }

    it 'returns success with false' do
      expect(subject).to be_success
      expect(subject.data).to eq false
    end
  end

  context 'when before style ids are different then after' do
    let(:after_style_ids) { [1, 2, 3] }
    let(:after_ocassion_ids) { before_ocassion_ids }

    it 'returns success with true' do
      expect(subject).to be_success
      expect(subject.data).to eq true
    end
  end

  context 'when before ocassion ids are different then after' do
    let(:after_style_ids) { before_style_ids }
    let(:after_ocassion_ids) { [] }

    it 'returns success with true' do
      expect(subject).to be_success
      expect(subject.data).to eq true
    end
  end

  context 'when before ocassion and style ids are different then after' do
    let(:after_style_ids) { [1] }
    let(:after_ocassion_ids) { [2, 3] }

    it 'returns success with true' do
      expect(subject).to be_success
      expect(subject.data).to eq true
    end
  end
end
