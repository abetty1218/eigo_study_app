class QuestionsController < ApplicationController

  def index
    @problem = Problem.find(params[:problem_id])
    @questions = @problem.questions
  end

  def destroy
    question = Question.find(params[:id])
    if question.destroy
      flash[:success] = "質問を削除しました。"
      redirect_to problem_questions_url
    end
  end
end
