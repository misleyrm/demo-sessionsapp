class RemoveActionFromNotification < ActiveRecord::Migration[5.1]
  def change
    remove_column :notifications, :action, :string
  end
end
