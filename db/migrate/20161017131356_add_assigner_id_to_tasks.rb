class AddAssignerIdToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :assigner_id, :integer
    add_index  :tasks, :assigner_id
  end
end
