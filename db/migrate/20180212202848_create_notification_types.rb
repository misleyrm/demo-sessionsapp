class CreateNotificationTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_types do |t|
      t.string :action
      t.string :string
      t.string :settings_text
      t.string :notification_text

      t.timestamps
    end
  end
end
