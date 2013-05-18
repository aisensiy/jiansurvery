class Survey < ActiveRecord::Base
  attr_accessible :questions, :description, :title
  validates_presence_of :title, :description, :questions
  serialize :questions, Array

  has_many :answers

  def save_from_json(json)
    self.title = json["title"]
    self.description = json["description"]
    self.questions = json["questions"]
  end
end
