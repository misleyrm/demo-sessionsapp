class AddActiveToInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :invitations, :active, :boolean
  end
end
