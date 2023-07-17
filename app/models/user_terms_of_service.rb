class UserTermsOfService < ApplicationRecord
  belongs_to :user
  belongs_to :term_of_service
end
