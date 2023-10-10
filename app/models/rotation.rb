# == Schema Information
#
# Table name: rotations
#
#  id             :bigint           not null, primary key
#  end_date       :date
#  name           :string
#  start_date     :date
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  institution_id :bigint           not null
#  manager_id     :bigint
#
# Indexes
#
#  index_rotations_on_institution_id  (institution_id)
#  index_rotations_on_manager_id      (manager_id)
#
# Foreign Keys
#
#  fk_rails_...  (institution_id => institutions.id)
#  fk_rails_...  (manager_id => managers.id)
#
class Rotation < ApplicationRecord
  include AASM
  belongs_to :institution
  belongs_to :manager
  has_many :subjects
  has_many :student_informations
  has_many :students, through: :student_informations
  has_many :activities


  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :active, -> { where(state: :active) }
  scope :no_active, -> { where(state: :no_active) }

  aasm column: 'state' do
    state :active, initial: true
    state :no_active

    event :activate do
      transitions from: :no_active, to: :active
    end

    event :deactivate do
      transitions from: :active, to: :no_active
    end
  end

  def institution_name
    institution.name
  end

  def manager_name
    manager.user_profile.full_name
  end

  def subject
    Subject.find(self.subject_id)
  end

  def as_json(options = {})
    super(options.merge(methods: [:manager_name, :institution_name]))
  end
end
