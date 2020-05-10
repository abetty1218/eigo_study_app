class ProblemsController < ApplicationController

  def new
    @problem = Problem.new
    @problem.questions.build
    @question_style = params[:question_style]
    @count = Problem.all.count
    set_question_choice
  end

  def create
    @problem = Problem.new(problem_params)
    @question_style = problem_params[:question_style]
    if @question_style == "1"
      choice_params = params["problem"]["questions_attributes"]["0"]["question_choices"]
    end
    @count = Problem.all.count
    if @problem.save
      question = Question.last
      if choice_params
        choice_params.keys.each do |id|
          choice = QuestionChoice.new
          choice.number = choice_params[id]["number"]
          choice.content = choice_params[id]["content"]
          choice.choice = choice_params[id]["choice"]
          choice.question_id = question.id
          choice.save
        end
      end
      flash[:success] = "問題を作成しました。"
      redirect_to problems_url
    else
      set_question_choice
      render 'new'
    end
  end

  def index
    @problems = Problem.all
    @problem = Problem.new
    @count = @problems.count
  end

  def answer_index
    @problem = Problem.find(params[:problem_id])
    @questions = @problem.questions
  end

  def released
    @problem = Problem.find(params[:id])
    if @problem.released == true
      @problem.released = false
      @problem.released_on = nil
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
    @try = params[:try]
    @problem = Problem.find(params[:id])
    @correct_count = current_user.question_answers.where(problem_id: params[:id]).where(correct: true).where(try: @try).count
    @question_count = @problem.questions.count
  end

  def destroy
    @problem = Problem.find(params[:id])
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
      params.require(:problem).permit(:question_style,:number, questions_attributes:[:id,:content,:answer,:description])
    end
end
