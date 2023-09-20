# == Schema Information
#
# Table name: activities
#
#  id            :bigint           not null, primary key
#  delivery_date :date
#  name          :string(200)
#  state         :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  unity_id      :bigint           not null
#
# Indexes
#
#  index_activities_on_unity_id  (unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (unity_id => unities.id)
#
class Activity < ApplicationRecord
  include AASM
  belongs_to :unity

  ACTIVITY_TYPES = %w[THEORETICAL PRACTICAL THEORETICAL_PRACTICAL]
  public_constant :ACTIVITY_TYPES

  validates :name, presence: true, length: { maximum: 200 }
  validates :type, presence: true, inclusion:{in: ACTIVITY_TYPES, message: "invalid activity type"}

  scope :in_progress, -> { where(state: :in_progress)}

  self.inheritance_column = :_type_disabled

  aasm column: 'state' do
    state :pending, initial: true
    state :in_progress
    state :completed
    state :canceled
    state :postponed

    event :start do
      transitions from: :pending, to: :in_progress
    end

    event :complete do
      transitions from: [:pending, :in_progress], to: :completed
    end

    event :cancel do
      transitions from: [:pending, :in_progress], to: :canceled
    end

    event :postpone do
      transitions from: [:pending, :in_progress], to: :postponed
    end
  end

  def days_until_delivery
    return 0 if delivery_date.nil?

    difference = delivery_date - Date.today

    return 0 if difference.negative?

    difference.to_i
  end


end
