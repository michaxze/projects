class AddGroupNameToHighlightCategories < ActiveRecord::Migration
  def self.up
    add_column :highlight_categories, :group_name, :string
  end

  def self.down
    drop_column :highlight_categories, :group_name
  end
end
