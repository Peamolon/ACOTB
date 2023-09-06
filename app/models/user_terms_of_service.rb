# == Schema Information
#
# Table name: user_terms_of_services
#
#  id                  :bigint           not null, primary key
#  accept_at           :datetime
#  ip_address          :string(60)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  terms_of_service_id :bigint           not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_user_terms_of_services_on_terms_of_service_id  (terms_of_service_id)
#  index_user_terms_of_services_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (terms_of_service_id => terms_of_services.id)
#  fk_rails_...  (user_id => users.id)
#
class UserTermsOfService < ApplicationRecord
  belongs_to :user
  belongs_to :term_of_service
end
