class AddNotificationOptionRefToNotificationSetting < ActiveRecord::Migration[5.1]
  def change
    remove_column :notification_settings, :user_id
    remove_column :notification_settings, :notification_type_id
    remove_column :notification_settings, :option

    add_reference :notification_settings, :notification_option, foreign_key: true
    add_reference :notification_settings, :user, foreign_key: true
    add_reference :notification_settings, :notification_type, foreign_key: true

    add_index :notification_settings, [:user_id, :notification_type_id, :notification_option_id], unique: true, :name => 'index_user_ntype_noption'
  end
end
