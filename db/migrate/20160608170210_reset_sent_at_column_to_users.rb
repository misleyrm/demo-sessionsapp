class ResetSentAtColumnToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :reset_sent_at, :datetime
  end
  def down
    remove_column :users, :reset_sent_at, :datetime
  end
end
