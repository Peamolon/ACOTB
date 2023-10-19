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
class Institution < ApplicationRecord
  belongs_to :manager
  validates :name, presence: true, length: { maximum: 100 }
  validates :code, presence: true, length: { maximum: 100 }
  validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
