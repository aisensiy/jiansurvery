class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :descrption
      t.text :content

      t.timestamps
    end
  end
end
