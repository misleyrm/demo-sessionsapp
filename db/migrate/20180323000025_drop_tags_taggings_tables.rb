class DropTagsTaggingsTables < ActiveRecord::Migration[5.1]
  def up
    drop_table :taggings
    drop_table :tags
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
