class AddRefToNotificationSetting < ActiveRecord::Migration[5.1]
  def change
    add_reference :notification_settings, :notification_type, foreign_key: true
    add_reference :notification_settings, :user, foreign_key: true
    add_index :notification_settings, [:user_id, :notification_type_id, :option], unique: true, :name => 'index_user_ntype_option'
  end
end
