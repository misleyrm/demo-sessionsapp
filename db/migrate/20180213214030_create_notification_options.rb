class CreateNotificationOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_options do |t|
      t.string :name

      t.timestamps null: true
    end
  end
end
