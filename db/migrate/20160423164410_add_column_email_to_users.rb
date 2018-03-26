class AddColumnEmailToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :email, :string
  end
  def down
    remove_column :users, :email, :string
  end
end
