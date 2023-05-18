class AddLockedAtToUsers < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :locked_at, :datetime
    add_column :users, :failed_attempts, :integer, default: 0, null: false
  end

  def self.down
    remove_column :users, :failed_attempts
    remove_column :users, :locked_at
  end
end
