class QuestionsController < ApplicationController

  def index
    @problem = Problem.find(params[:problem_id])
    @questions = @problem.questions
  end

  def new
    @problem = Problem.find(params[:problem_id])
    @question = @problem.questions.build
    set_question_choice
  end

  def create
    @question = Question.new(question_params)
    @problem = Problem.find(params[:problem_id])
    if @question.save
      if choice_params
        choice_params.keys.each do |id|
          choice = QuestionChoice.new(choice_params[id])
          choice.question_id = @question.id
          choice.save
        end
      end
      flash[:success] = "質問を作成しました。"
      redirect_to problem_questions_url
    else
      set_question_choice
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    @problem = Problem.find(params[:problem_id])
    @question_choices = @question.question_choices
  end

  def update
    @question = Question.find(params[:id])
    first_choice = @question.question_choices.find_by(choice: true);
    if @question.update_attributes(question_params)
      if choice_params.present?
        choice_params.keys.each do |id|
          choice = QuestionChoice.find(id)
          choice.update_attributes(choice_params[id])
        end
        update_choice = @question.question_choices.where.not(id: first_choice.id).where(choice: true).first
        if !update_choice.nil? && !first_choice.nil?
          first_choice.choice = false
          first_choice.save
        end
      end
      flash[:success] = "質問を編集しました。"
      redirect_to problem_questions_url
    else
      render "edit"
    end
  end

  def destroy
    question = Question.find(params[:id])
    if question.destroy
      flash[:success] = "質問を削除しました。"
      redirect_to problem_questions_url
    end
  end

  private
    def question_params
      params.require(:question).permit(:content, :answer, :description, :problem_id)
    end

    def choice_params
      params.require(:question).permit(question_choices: [:choice,:content])[:question_choices]
    end
end
