class AnswersController < ApplicationController
  def create
    @survey = Survey.find(params[:survey_id])
    @answer = @survey.answers.build(content: params[:json])

    respond_to do |format|
      if @answer.save
        format.json { render json: {success: true} }
      else
        format.json { render json: {success: false} }
      end
    end
  end
end
