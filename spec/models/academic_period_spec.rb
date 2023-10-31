require 'rails_helper'

RSpec.describe AcademicPeriod, type: :model do
  describe "validations" do
    it "validates presence of required fields" do
      should validate_presence_of(:start_date)
      should validate_presence_of(:end_date)
      should validate_presence_of(:number)
    end
  end

  it "returns nil if there is no academic period close to today" do
    academic_period = described_class.create(
      start_date: Date.current + 30.days,
      end_date: Date.current + 45.days,
      number: 3
    )

    closest_period = described_class.closest_to_today
    puts closest_period
    expect(closest_period).to be_nil
  end
end