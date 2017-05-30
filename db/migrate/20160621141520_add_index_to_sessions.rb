class AddIndexToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :team_id, :integer
    add_index :sessions, :team_id
  end
end
