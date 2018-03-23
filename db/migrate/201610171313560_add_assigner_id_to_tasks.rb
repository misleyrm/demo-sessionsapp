class AddAssignerIdToTasks < ActiveRecord::Migration[5.0]
  def up
    remove_column :tasks, :assigner_id
    add_column :tasks, :assigner_id, :integer
    add_index  :tasks, :assigner_id
  end

  def down
    remove_index :tasks, :assigner_id
  end
end
