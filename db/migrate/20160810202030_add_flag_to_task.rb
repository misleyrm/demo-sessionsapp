class AddFlagToTask < ActiveRecord::Migration[5.0]
  def up
    add_column :tasks, :flag, :boolean,  default: false
  end
  def down
    remove_column :tasks, :flag
  end
end
