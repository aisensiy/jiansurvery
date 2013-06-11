FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "0000000a"
    password_confirmation "0000000a"
    # factory :admin do
    #   is_admin true
    # end
  end
end

