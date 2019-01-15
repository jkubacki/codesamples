# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shoper::ProductCategory, type: :model do
  it { is_expected.to belong_to :product }
  it { is_expected.to belong_to :category }

  it { is_expected.to validate_presence_of :product }
  it { is_expected.to validate_presence_of :category }
end
