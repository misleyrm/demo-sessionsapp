class DropTagsTaggingsTables < ActiveRecord::Migration[5.1]
  def up
    drop_table :taggings, if_exists: true
    drop_table :tags, if_exists: true
  end

end
