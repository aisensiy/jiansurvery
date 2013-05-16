class Survey < ActiveRecord::Base
  attr_accessible :questions, :description, :title
  validates_presence_of :title, :description, :questions

  def save_from_json(json)
    self.title = json["title"]
    self.description = json["description"]
    self.questions = json["questions"].to_json
  end
end
