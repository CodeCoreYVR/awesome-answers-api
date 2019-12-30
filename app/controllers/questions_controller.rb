class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  def new
    @question = Question.new
  end

  def create
    # # The 'params' object available in controllers
    # # is composed of the query string, url params,
    # # and the body of a form
    # # (e.g. req.query + req.params + req.body)
    #
    # # A good trick to see if your routes are working
    # # and you're getting the data that you want, is to
    # # render the params as JSON. This is like doing
    # # res.send(req.body) in Express

    # Use 'require' on the params object to retrieve
    # the nested hash of a key usually corresponding to
    # the name-value pairs of a form

    # Then use permit to specify all input names that
    # are allowable (as symbols).
    @question = Question.new question_params
    @question.user = current_user
    if @question.save
      flash[:notice] = "Question created successfully"
      # if question is saved successfully redirect to question show page
      redirect_to question_path(@question)
    else
      # render views/questions/new.html.erb
      render :new
    end
  end

  def show
    # For the 'form_with' helper
    @answer = Answer.new
    # For the list of answers
    @likes = @question.likes.count
    @answers = @question.answers.order(created_at: :desc)
  end

  def index
    if params[:tag]
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @questions = @tag.questions.viewable.order(created_at: :desc)
    else
      @questions = Question.viewable.order(created_at: :desc)
      respond_to do |format|
        format.html { render  }
        format.json { render json: @questions }
      end
    end
  end

  def edit
  end

  def update
    # attempt to edit the existing question with new values
    if @question.update question_params
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = "Question destoryed!"
    @question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    # params.require(:question): We must have a question object on the params of this request
    # .permit(:title, :body): for security reasons we need to only permit the title and body keys/attributes of the question
    params.require(:question).permit(:title, :body, :tag_names, :image)
  end

  def find_question
    # get the current value inside of the db
    @question = Question.find params[:id]
  end

  def authorize!
    redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, @question)
  end
end
