require 'json'

class SurveysController < ApplicationController
  layout "survey_base"
  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all

    respond_to do |format|
      format.html { render "index", layout: "application" }
      format.json { render json: @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @survey = Survey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @survey }
    end
  end

  # GET /surveys/new
  # GET /surveys/new.json
  def new
    @survey = Survey.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Survey.find(params[:id])
  end

  # POST /surveys
  # POST /surveys.json
  def create
    json = params[:survey]
    json[:questions] = JSON.parse(json[:questions])
    @survey = Survey.new(json)
    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render json: @survey, status: :created, location: @survey }
      else
        format.html { render action: "new" }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.json
  def update
    @survey = Survey.find(params[:id])
    json = params[:survey]
    json[:questions] = JSON.parse(json[:questions])

    respond_to do |format|
      if @survey.update_attributes(json)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render json: @survey }
      else
        format.html { render action: "edit" }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to surveys_url }
      format.json { head :no_content }
    end
  end

  def result
    @survey = Survey.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        answers = Answer.where('survey_id = ?', @survey.id)
        render json: answers
      end
    end
  end

  private
  def statistic


  end
end
