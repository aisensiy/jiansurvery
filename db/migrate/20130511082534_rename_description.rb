class RenameDescription < ActiveRecord::Migration
  def up
    remove_column :surveys, :descrption
    add_column :surveys, :description, :text
  end

  def down
    remove_column :surveys, :description
    add_column :surveys, :descrption, :text
  end
end
