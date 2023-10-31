# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCalification, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:activity) }
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:rotation) }
    it { is_expected.to have_many(:bloom_taxonomy_levels) }
  end
end
