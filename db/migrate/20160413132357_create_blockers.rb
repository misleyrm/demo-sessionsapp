class CreateBlockers < ActiveRecord::Migration
  def change
    create_table :blockers do |t|
      t.integer :session_id
      t.integer :user_id
      t.text :blocker

      t.timestamps null: false
    end
  end
end
