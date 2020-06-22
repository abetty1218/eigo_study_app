require 'rails_helper'
describe ProblemsController do
#
  describe 'Get #index' do
    context "未ログイン時" do
      before do
        @problems = create(:problem)
        get 'index'
      end
      it 'リクエストは200 OKとなること'  do
        expect(response.status).to eq 302
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problems = create(:problem)
        get 'index'
      end
      it 'リクエストは200 OKとなること'  do
        expect(response.status).to eq 200
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    context "未ログイン時" do
      before { get :new, params: {}, session: {} }
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'renders the :new template' do
         expect(response).to redirect_to(root_path)
      end
    end
    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        get :new, params: {}, session: {}
      end
      it 'has a 200 status code' do
        expect(response.status).to eq 200
      end
      it 'assigns new @problem' do
        expect(assigns(:problem)).to be_a_new Problem
      end
      it 'renders the :new template' do
         expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    before do
      @problem = attributes_for(:problem)
      @problem2 = attributes_for(:problem2)
      @question = attributes_for(:question)
      @choice = attributes_for(:question_choice)
    end
    context "未ログイン時" do
      it 'saves new problem' do
        expect do
          post :create, params: { problem: @problem}
        end.to change(Problem, :count).by(0)
      end
      it 'redirects the :create template' do
        post :create, params: { problem: @problem}, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
      end
      it 'saves new problem 記述式' do
        @problem["questions_attributes"] = {"0" => @question}
        expect do
          post :create, params: { problem: @problem}
        end.to change(Problem, :count).by(1).and change(Question, :count).by(1)
      end
      it 'saves new problem　選択式' do
        @problem2["questions_attributes"] = {"0" => @question}
        @problem2["questions_attributes"]["0"]["question_choices_attributes"] = {"0" => @choice}
        expect do
          post :create, params: { problem: @problem2}
        end.to change(Problem, :count).by(1).and change(Question, :count).by(1).and change(QuestionChoice, :count).by(1)
      end

      it 'redirects the :create template' do
        post :create, params: { problem: @problem}, session: {}
        expect(response).to redirect_to(problems_path)
      end
    end
  end
  describe 'GET #complete' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        get :complete, params: {id: @problem.id}, session: {}
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'renders the :new template' do
         expect(response).to redirect_to(root_path)
      end
    end
    context "一般ログイン時" do
      before do
        @user = create(:user)
        log_in_as(@user)
        @problem = create(:problem)
        get :complete, params: {id: @problem.id}, session: {}
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 200
      end
      it 'renders the :complete template' do
         expect(response).to render_template :complete
      end
    end
  end

  describe 'GET #released' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        get :complete, params: {id: @problem.id}, session: {}
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'renders the :released template' do
         expect(response).to redirect_to(root_path)
      end
    end

    context "一般ログイン時" do
      let(:update_attributes) do
        {
          released: true,
          released_on: Date.current
        }
      end
      let(:update_attributes_1) do
        {
          released: false,
          released_on: nil
        }
      end
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
        @problem1 = create(:problem1)
      end

      it 'updates updated problem' do
        patch :released, params: { id: @problem.id, problem: update_attributes }, session: {}
        @problem.reload
        expect(@problem.released).to eq update_attributes[:released]
        expect(@problem.released_on).to eq update_attributes[:released_on]
      end

      it 'updates updated problem1' do
        patch :released, params: { id: @problem1.id, problem: update_attributes_1 }, session: {}
        @problem1.reload
        expect(@problem1.released).to eq update_attributes_1[:released]
        expect(@problem1.released_on).to eq update_attributes_1[:released_on]
      end

      it 'redirects the :create template' do
        patch :released, params: { id: @problem.id, problem: update_attributes}, session: {}
        expect(response).to redirect_to(problems_path)
      end

    end
  end

  describe 'DELETE #destroy' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
      end
      it 'deletes the problem' do
        expect do
          delete :destroy, params: { id: @problem.id }, session: {}
        end.to change(Problem, :count).by(0)
      end
      it 'redirects the :create template' do
        delete :destroy, params: { id: @problem.id }, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
      end
      it 'deletes the problem' do
        expect do
          delete :destroy, params: { id: @problem.id }, session: {}
        end.to change(Problem, :count).by(-1)
      end
      it 'redirects the :create template' do
        delete :destroy, params: { id: @problem.id }, session: {}
        expect(response).to redirect_to(problems_path)
      end
    end
  end
end
