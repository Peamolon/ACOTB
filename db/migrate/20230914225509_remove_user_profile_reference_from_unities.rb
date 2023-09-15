class RemoveUserProfileReferenceFromUnities < ActiveRecord::Migration[6.0]
  def change
    remove_reference :unities, :user_profiles, foreign_key: true, index: true
  end
end
