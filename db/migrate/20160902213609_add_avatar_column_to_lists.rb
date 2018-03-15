class AddAvatarColumnToLists < ActiveRecord::Migration[5.0]
  def up
   add_attachment :lists, :avatar
 end

 def down
   remove_attachment :lists, :avatar
 end
end
