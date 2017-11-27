class AddDefaultValueToActive < ActiveRecord::Migration[5.1]
  def up
    change_column :invitations, :active, :boolean, default: false
  end

  def down
    change_column :invitations, :active, :boolean, default: nil
  end

end
