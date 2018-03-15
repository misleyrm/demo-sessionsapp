class AddRecipientToInvitation < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :recipient_id, :integer
  end
end
