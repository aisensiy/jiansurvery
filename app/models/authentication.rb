class Authentication < ActiveRecord::Base
  scope :weibo, where(provider: "weibo")
  attr_accessible :provider, :uid, :user_id, :access_token, :expires_at

  belongs_to :user

end
