class CreateNotificationSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_settings do |t|
      t.boolean :active
      t.integer :option
      t.timestamps null: false
    end
    add_index :users, :user_id
    add_index :notification_types, :notification_type_id
  end
end
