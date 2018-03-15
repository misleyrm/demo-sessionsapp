class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|

      t.timestamps null: false
    end
  end
end
