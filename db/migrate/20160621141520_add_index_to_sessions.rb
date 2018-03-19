class AddIndexToSessions < ActiveRecord::Migration[5.0]
  def change
    add_column :sessions, :team_id, :integer
    add_index :sessions, :team_id
  end
end
