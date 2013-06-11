# -*- encoding: utf-8 -*-

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey do
    title "test"
    description "this is a test survey"
    questions [
      {"id"=>1, "type"=>"multi-choice", "content"=>"test", "choices"=>[{"content"=>"第一个选项", "other"=>false}, {"content"=>"第二个选项", "other"=>false}, {"content"=>"第三个选项", "other"=>false}, {"content"=>"第四个选项", "other"=>false}, {"content"=>"其他", "other"=>true}], "other"=>true}
    ]
    association :user
  end
end
