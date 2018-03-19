class AddListIdUserIdCollaborationDateToCollaboration < ActiveRecord::Migration[5.0]
  def up
    add_column :collaborations, :user_id, :integer
    add_index :collaborations, :user_id
    add_column :collaborations, :list_id, :integer
    add_index :collaborations, :list_id
    add_column :collaborations, :collaboration_date, :datetime
  end
  def down
    remove_column :collaborations, :user_id, :integer
    remove_column :collaborations, :list_id, :integer
    remove_column :collaborations, :collaboration_date, :datetime
  end
end
