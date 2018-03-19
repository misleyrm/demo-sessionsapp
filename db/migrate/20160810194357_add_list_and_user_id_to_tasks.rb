class AddListAndUserIdToTasks < ActiveRecord::Migration[5.0]
  def up
    add_column :tasks, :detail, :string
    add_column :tasks, :parent_task_id, :integer
    add_index :tasks, :parent_task_id
    add_column :tasks, :collaboration_id, :integer
    add_index :tasks, :collaboration_id
    add_column :tasks, :list_id, :integer
    add_index :tasks, :list_id
    add_column :tasks, :user_id, :integer
    add_index :tasks, :user_id
  end

  def down
    remove_column :tasks, :detail
    remove_column :tasks, :parent_task_id
    remove_column :tasks, :collaboration_id
    remove_column :tasks, :list_id
    remove_column :tasks, :user_id
  end

end
