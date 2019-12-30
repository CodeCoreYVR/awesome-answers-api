class Api::V1::QuestionsController < Api::ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  rescue_from(ActiveRecord::RecordNotFound, with: :record_not_found)
  rescue_from(ActiveRecord::RecordInvalid, with: :record_invalid)

  def index
    questions = Question.order(created_at: :desc)
    render(json: questions, each_serializer: QuestionCollectionSerializer)
  end

  def show
    if @question
    render(
      json: @question,
      # We need to do this to make sure that Rails
      # includes the nested user association for answers
      # (which is renamed to author in the serializer).
      include: [ :author, {answers: [ :author ]} ]
    )
    else
      render(json: {error: 'Question Not found'})
    end
  end

  def create
    question = Question.new question_params
    question.user = current_user
    question.save!
    render json: { id: question.id }
  end

  def edit 
  end

  def update
    if @question.update question_params
      render json: { id: @question.id }
    else
      render :edit
    end

  end

  def destroy
    @question.destroy
    render(json: { status: 200 }, status: 200)
  end

  private

  def find_question
    @question ||= Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_names)
  end

  def record_not_found
    render(
      json: { status:422, errors: {msg: 'Record Not Found'}},
      status: 422
    )
  end

  def record_invalid(error)
    invalid_record = error.record
    errors = invalid_record.errors.map do |field, message|
      {
        type: error.class.to_s,
        record_type: invalid_record.class.to_s,
        field: field,
        message: message,
      }
    end
    render(
      json: { status:422, errors: errors }
    )
  end
end
