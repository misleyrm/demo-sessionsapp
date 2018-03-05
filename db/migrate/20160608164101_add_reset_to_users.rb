class AddResetToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :reset_digest, :string
  end
  def down
    remove_column :users, :reset_digest, :string
  end
end
