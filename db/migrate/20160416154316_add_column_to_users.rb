class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :attended, :boolean, :default => false
  end
end
