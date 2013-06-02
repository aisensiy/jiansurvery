class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :uid
      t.string :provider
      t.integer :user_id
      t.string :access_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
