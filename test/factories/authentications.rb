# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    uid "MyString"
    provider "MyString"
    user_id 1
    access_token "MyString"
    expires_at "2013-05-30 15:05:49"
  end
end
