class AddAvatarColumnToLists < ActiveRecord::Migration
  def up
   add_attachment :lists, :avatar
 end

 def down
   remove_attachment :lists, :avatar
 end
end
