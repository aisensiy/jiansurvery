class ChangeColumns < ActiveRecord::Migration
  def up
    rename_column :surveys, :content, :questions
  end

  def down
    rename_column :surveys, :questions, :content
  end
end
