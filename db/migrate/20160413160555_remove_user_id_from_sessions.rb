class RemoveUserIdFromSessions < ActiveRecord::Migration[5.1]
  def up
    remove_column :sessions, :user_id, :integer
  end
  def down
    add_column :sessions, :user_id, :integer
  end
end
