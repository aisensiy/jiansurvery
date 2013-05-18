class Answer < ActiveRecord::Base
  attr_accessible :content, :survey_id
  serialize :content, Hash

  belongs_to :survey
end
