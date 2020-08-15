class ProblemsController < ApplicationController
  before_action :logged_in, only: [:index]
  before_action :logged_in_user, only: [:complete]
  before_action :logged_in_admin, only: [:create,:destroy,:new,:released]

  def new
    @problem = Problem.new
    @question = @problem.questions.build
    @question.question_choices.build
    @question_style = params[:question_style]
    @count = Problem.all.count
  end

  def create
    @problem = Problem.new(problem_params)
    @question_style = problem_params[:question_style]
    @count = Problem.all.count
    if @problem.save
      flash[:success] = "問題を作成しました。"
      redirect_to problems_url
    else
      render 'new'
    end
  end

  def index
    @problems = Problem.all
    @problem = Problem.new
    @count = @problems.count
  end

  def released
    @problem = Problem.find(params[:id])
    if @problem.released == true
      @problem.released = false
      @problem.released_on = nil
      if @problem.question_answers
        @problem.question_answers.delete_all
      end
    else
      @problem.released = true
      @problem.released_on = Date.current
    end
    if @problem.save
      flash[:success] = "公開状況を変更しました。"
      redirect_to problems_url
    else
      @problems = Problem.all
      @count = @problems.count
      render 'index'
    end
  end

  def complete
    @try = params[:try].to_i
    @problem = Problem.find(params[:id])
    @correct_count = current_user.question_answers.get_problem_answer(params[:id],@try).where(correct: true).count
    @question_count = @problem.questions.count
  end

  def destroy
    @problem = Problem.find(params[:id])
    number = @problem.number
    if @problem.destroy
      @problems = Problem.where("number > ?", number)
      @problems.each do |problem|
        problem.number = problem.number - 1
        problem.save
      end
      flash[:success] = "問題を削除しました。"
      redirect_to problems_url
    end
  end

  private
    def problem_params
       params.require(:problem).permit(:id,:question_style,:number,
         questions_attributes: [:id, :content, :answer, :japaneseexample, :englishexample, :_destroy,
           question_choices_attributes: [:id, :choice, :content, :_destroy]
         ]
       )
    end
end
