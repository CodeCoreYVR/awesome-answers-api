class PublishingsController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find params[:question_id]
    question.publish!
    redirect_to question, notice: "Question published!"
  end
end
