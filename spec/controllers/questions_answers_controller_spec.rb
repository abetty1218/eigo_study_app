require 'rails_helper'
describe QuestionsAnswersController do
  describe 'POST #create' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @user = create(:user)
        @question = create(:question)
        @answer = attributes_for(:question_answer,problem_id: @problem.id, question_id: @question.id, user_id: @user.id,try: 1)
      end
      it 'saves question_answer' do
        expect do
          post :create, params: { question_answer: @answer}
        end.to change(QuestionAnswer, :count).by(0)
      end

      it 'redirects the :create template' do
        post :create, params: { question_answer: @answer}, session: {}
        expect(response).to redirect_to(root_url)
      end
    end

    context "一般ユーザーログイン時" do
      before do
        @user = create(:user)
        log_in_as(@user)
        @problem = create(:problem)
        @question = create(:question)
        @try = 1
        @answer = attributes_for(:question_answer,problem_id: @problem.id, question_id: @question.id, user_id: @user.id, try: @try)
        @non_answer = attributes_for(:non_answer,problem_id: @problem.id, question_id: @question.id, user_id: @user.id, try: @try)
      end
      it 'create question_answer' do
        expect do
          post :create, params: { question_answer: @answer}
        end.to change(QuestionAnswer, :count).by(1)
      end

      it 'redirects the :create template' do
        post :create, params: { question_answer: @answer}, session: {}
        expect(response).to redirect_to(answer_problem_question_url(@problem.id,@question.id,try: @try))
      end

      it 'save correct true' do
        post :create, params: { question_answer: @answer}, session: {}
        answer = QuestionAnswer.last
        expect(answer.correct).to eq true
      end

      it 'save correct false' do
        post :create, params: { question_answer: @non_answer}, session: {}
        answer = QuestionAnswer.last
        expect(answer.correct).to eq false
      end
    end

  end
end
