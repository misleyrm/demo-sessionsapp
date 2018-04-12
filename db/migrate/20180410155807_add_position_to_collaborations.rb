class AddPositionToCollaborations < ActiveRecord::Migration[5.1]
   def self.up
     add_column :collaborations, :position, :integer
   end

   def self.down
     remove_column :collaborations, :position
   end
end
