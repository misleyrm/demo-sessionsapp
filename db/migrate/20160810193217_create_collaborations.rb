class CreateCollaborations < ActiveRecord::Migration[5.1]
  def change
    create_table :collaborations do |t|

      t.timestamps null: false
    end
  end
end
