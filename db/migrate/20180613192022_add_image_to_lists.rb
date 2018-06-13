class AddImageToLists < ActiveRecord::Migration[5.1]
  def up
    add_column :lists, :image, :string
  end

  def down
    remove_column :lists, :image, :string
  end
end
