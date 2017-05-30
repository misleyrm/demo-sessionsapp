class AddAssignerIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :assigner_id, :integer
    add_index  :tasks, :assigner_id
  end
end
