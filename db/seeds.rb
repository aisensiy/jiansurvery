# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

survey = FactoryGirl.create :survey
FactoryGirl.create :answer, survey: survey
FactoryGirl.create :answer, survey: survey, content: {"field1" => "1"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "2"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "3"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "3"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "4"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "4"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "4"}
FactoryGirl.create :answer, survey: survey, content: {"field1" => "4"}
