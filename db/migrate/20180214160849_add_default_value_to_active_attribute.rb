class AddDefaultValueToActiveAttribute < ActiveRecord::Migration[5.1]
  def up
    change_column :notification_settings, :active, :boolean, default: true
  end

  def down
    change_column :notification_settings, :active, :boolean, default: nil
  end
end
