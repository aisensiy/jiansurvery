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
    json[:questions].each_with_index do |question, idx|
      json[:questions][idx]['id'] = idx + 1
    end
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
    filter = JSON.parse(params[:filter] || '{}')
    logger.debug filter.inspect
    respond_to do |format|
      format.html
      format.json do
        render json: {title: @survey.title, result: statistic(@survey, filter)}
      end
    end
  end

  private
  def statistic(survey, filter)
    result = {}

    survey.questions.each_with_index do |question, index|

      case question["type"]
      when /text/
        name = "field#{question["id"]}"
        result[name] = {
          'type' => 'text',
          'content' => question["content"],
          'url' => '',
          'results' => {}
        }
      when /choice/
        name = "field#{question["id"]}"
        result[name] = {
          'content' => question["content"],
          'results' => {}
        }
        question_result = []
        for choice in question["choices"]
          question_result << {
            'content' => choice["content"],
            'count' => 0
          }

          if choice['other']
            result["other#{index + 1}"] = {
              'type' => 'other',
              'content' => "#{question["content"]} => #{choice["content"]}",
              'url' => "",
              'results' => []
            }
          end
        end
        result[name]['results'] = question_result
      when /dropdown/
        name = "field#{question["id"]}"
        result[name] = {
          'content' => question["content"],
          'results' => []
        }
        question_result = question["choices"].map do |choice|
          {
            'content' => choice,
            'count' => 0
          }
        end
        result[name]['results'] = question_result
      when 'matrix'
        choices = question['vals'];
        for subq in question['questions']
          name = "field#{subq[1]}"
          result[name] = {
            'content' => $subq[0],
            'results' => []
          }
          sub_res = choices.map do |choice|
            {
              'content' => $choice,
              'count' => 0
            }
          end
          result[name]['results'] = sub_res;
        end
      end
    end

    survey.answers.each do |answer|
      valid = true
      answer = answer.content
      answer.each do |field, reply|
        reply_arr = reply.instance_of?(Array) ? reply : [reply]
        if !in_filter?(filter, field, reply_arr)
          valid = false
          break
        end
      end
      filter.each do |k, v|
        if !answer.key?(k)
          valid = false
          break
        end
      end
      next if !valid
      logger.debug result
      answer.each do |field, reply|
        if result[field] &&
           result[field]['type'] &&
           /^(text)|(other)$/i =~ result[field]['type']
          result[field]['results'] << reply
          next
        elsif field =~ /other/
          next
        end
        logger.debug field
        reply = reply.instance_of?(Array) ? reply : [reply]
        reply.each { |answer_id| result[field]['results'][answer_id.to_i - 1]['count'] += 1 if result[field]['results'][answer_id.to_i - 1] }
      end
    end
    result
  end

  def in_filter?(filter, field, values)
    return true if filter.size == 0
    values.each do |value|
      next if not filter.key? field
      if filter[field].include? value
        return true
      end
    end
    false
  end

end
