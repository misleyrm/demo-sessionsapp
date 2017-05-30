class ResetSentAtColumnToUsers < ActiveRecord::Migration
  def up
    add_column :users, :reset_sent_at, :datetime
  end
  def down
    remove_column :users, :reset_sent_at, :datetime
  end
end
