class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :survey_id
      t.text :content

      t.timestamps
    end
  end
end
