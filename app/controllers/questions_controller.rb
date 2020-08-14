class QuestionsController < ApplicationController
  before_action :logged_in_admin, only: [:index,:create,:destroy,:new,:edit,:update,:edit_all,:update_all]
  before_action :logged_in_user, only: [:answer_index,:answer,:show]

  def index
    @problem = Problem.find(params[:problem_id])
    @questions = @problem.questions
  end

  def new
    @problem = Problem.find(params[:problem_id])
    @question = @problem.questions.build
    @question.question_choices.build
    @count = @problem.questions.count
  end

  def create
     @problem = Problem.find(params[:problem_id])
     @count = @problem.questions.count
     if @problem.update_attributes(problem_params)
       flash[:success] = "質問を作成しました。"
       redirect_to problem_questions_url
     else
       render 'new'
     end
   end

  def edit
    @question = Question.find(params[:id])
    @problem = Problem.find(params[:problem_id])
    @update = true
    @number = 0
    @update_number = 0
  end

  def edit_all
    @problem = Problem.find(params[:problem_id])
    @update = true
  end

  def update
    @update = true
    @question = Question.find(params[:id])
    @problem = Problem.find(params[:problem_id])
    choice = @question.question_choices.find_by(choice: true);
    if @problem.question_style == 1
      @question.question_choices.each_with_index do |choice, index|
        if choice.choice == true
          @number = index
        end
      end
      question_update_params["question_choices_attributes"].each do |index,choice|
        if choice["choice"] == "true"
          @update_number = index
        end
      end
    end
    if @question.update_attributes(question_update_params)
      if question_update_params["question_choices_attributes"].present?
        update_choice = @question.question_choices.where.not(id: choice.id).where(choice: true).first
        if !update_choice.nil? && !choice.nil?
          choice.choice = false
          choice.save
        end
      end
      flash[:success] = "質問を編集しました。"
      redirect_to problem_questions_url
    else
      @update = false
      render "edit"
    end
  end

  def update_all
    @problem = Problem.find(params[:problem_id])
    choice = QuestionChoice.where(question_id: 1).where(choice: true);
    if @problem.question_style == 1
      @number = []
      @problem.questions.each do |question|
        question.question_choices.each_with_index do |choice, index|
          if choice.choice == true
            @number.push(index)
          end
        end
      end
      @update_number = []
      problem_params["questions_attributes"].each do |key,question|
        question["question_choices_attributes"].each do |index,choice|
          if choice["choice"] == "true"
            @update_number.push(index)
          end
        end
      end
      @number = @number.to_json.html_safe
      @update_number = @update_number.to_json.html_safe
    end
    if @problem.update_attributes(problem_params)
      problem_params["questions_attributes"].keys.each do |id|
        if problem_params["questions_attributes"][id]["question_choices_attributes"].present? && problem_params["questions_attributes"][id]["_destroy"] == "false"
          question_id = problem_params["questions_attributes"][id]["id"]
          choice = QuestionChoice.where(question_id: question_id).where(choice: true);
          first_choice = choice.order(updated_at: :asc).first
          if !choice.where.not(id: first_choice.id).nil?
            update_choice = choice.where.not(id: first_choice.id).first
          end
            if !update_choice.nil? && !first_choice.nil?
              first_choice.choice = false
              first_choice.save
            end
        end
      end
      flash[:success] = "質問を編集しました。"
      redirect_to problem_questions_url
    else
      @update = false
      render 'edit_all'
    end
  end

  def answer
    @try = params[:try].to_i
    @problem = Problem.find(params[:problem_id])
    @question = Question.find(params[:id])
    @question_answer = QuestionAnswer.new
    @question_count = @problem.questions.count
    @answer  = current_user.question_answers.where(problem_id: params[:problem_id]).where(try: @try).where(question_id: params[:id]).first
    @answer_count = current_user.question_answers.where(problem_id: params[:problem_id]).where(try: @try).count
  end

  def show
    @problem = Problem.find(params[:problem_id])
    @question = Question.find(params[:id])
  end

  def answer_index
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

  private
    def question_update_params
      params.require(:question).permit(:id, :content, :answer, :japaneseexample, :englishexample, question_choices_attributes: [:id, :choice,:content,:_destroy])
    end

    def problem_params
      params.require(:problem).permit(:id,
        questions_attributes: [:id, :content, :answer, :japaneseexample, :englishexample, :_destroy,
          question_choices_attributes: [:id, :choice, :content, :_destroy]
        ]
      )
    end
end
