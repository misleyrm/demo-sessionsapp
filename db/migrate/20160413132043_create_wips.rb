class CreateWips < ActiveRecord::Migration[5.1]
  def change
    create_table :wips do |t|
      t.integer :session_id
      t.integer :user_id
      t.text :wip_item

      t.timestamps null: false
    end
  end
end
