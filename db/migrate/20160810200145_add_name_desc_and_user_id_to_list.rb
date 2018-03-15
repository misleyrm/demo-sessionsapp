class AddNameDescAndUserIdToList < ActiveRecord::Migration[5.0]
  def up
    add_column :lists, :name, :string
    add_column :lists, :description, :string
    add_column :lists, :user_id, :integer
    add_index :lists, :user_id
  end
  def down
    remove_column :lists, :name
    remove_column :lists, :description
    remove_column :lists, :user_id
  end
end
