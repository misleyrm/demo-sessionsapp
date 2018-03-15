class CreateCompleteds < ActiveRecord::Migration[5.0]
  def change
    create_table :completeds do |t|
      t.integer :session_id
      t.integer :user_id
      t.text :completed

      t.timestamps null: false
    end
  end
end
