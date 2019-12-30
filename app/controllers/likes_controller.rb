class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    question = Question.find(params[:question_id])
    like = Like.new({user: current_user, question: question})

    if not can?(:like, question)
      flash[:danger] = "liking your own question? wow..."
      return redirect_to question_path(question)
    end

    if like.save
      redirect_to question_path(question), notice: "Thanks for liking!"
    else
      redirect_to question_path(question), alert: like.errors.full_messages.join(",")
    end
  end

  def destroy
    question = Question.find params[:question_id]
    like = Like.find params[:id]
    
    if like.destroy
      redirect_to question_path(question), notice: "😦"
    else 
      redirect_to question_path(question), alert: like.errors.full_messages.join(",")
    end
  end
end