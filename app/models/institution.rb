class Institution < ApplicationRecord
  belongs_to :manager
  validates :name, presence: true, length: { maximum: 100 }
  validates :code, presence: true, length: { maximum: 100 }
  validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
