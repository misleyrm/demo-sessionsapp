class AddAllTasksToLists < ActiveRecord::Migration[5.0]
  def up
    add_column :lists, :all_tasks, :boolean,  default: false
  end
  def down
    remove_column :lists, :all_tasks
  end
end
