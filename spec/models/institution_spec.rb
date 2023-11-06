# == Schema Information
#
# Table name: institutions
#
#  id                :bigint           not null, primary key
#  code              :string(32)
#  contact_email     :string(128)
#  contact_telephone :string(30)
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  manager_id        :bigint           not null
#
# Indexes
#
#  index_institutions_on_manager_id  (manager_id)
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => managers.id)
#
require 'rails_helper'

RSpec.describe Institution, type: :model do
  describe 'Associations' do
    it { should belong_to(:manager) }
    it { should have_many(:rotations) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_presence_of(:code) }
    it { should validate_length_of(:code).is_at_most(100) }
    it { should allow_value('example@example.com').for(:contact_email) }
    it { should_not allow_value('invalid_email').for(:contact_email) }
  end
end
