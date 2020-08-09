class QuestionsAnswersController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @question_answer = QuestionAnswer.new(answer_params)
    @problem = Problem.find(answer_params[:problem_id])
    @question = Question.find(answer_params[:question_id])
    if @problem.question_style == 2
      answer = @question.answer
    else
      @question.question_choices.each_with_index do |choice, id|
        if choice.choice == true
          answer = (id + 1).to_s
        end
      end
    end

    if answer == answer_params[:answer]
      @question_answer.correct = true
    end
    if @question_answer.save
      @try = answer_params[:try].to_i
      @question_count = @problem.questions.count
      @answer  = current_user.question_answers.where(problem_id: @problem.id).where(try: @try).where(question_id: @question.id).first
      @answer_count = current_user.question_answers.where(problem_id: @problem.id).where(try: @try).count
      @form_answer = answer_params[:answer]
      render "questions/answer"
      # redirect_to answer_problem_question_url(answer_params[:problem_id],answer_params[:question_id],try: answer_params[:try])
    else
      flash[:danger] = "回答を入力してください"
      redirect_to answer_problem_question_url(answer_params[:problem_id],answer_params[:question_id],try: answer_params[:try])
    end
  end

  private
    def answer_params
      params.require(:question_answer).permit(:problem_id, :question_id, :answer, :user_id, :try)
    end
end
