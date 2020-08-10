require 'rails_helper'
describe QuestionsController do
#
  describe 'Get #edit' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @question = create(:question)
        get 'edit', params: { id: @question.id,problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 302
      end
      it ':editテンプレートを表示すること' do
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
        @question = create(:question)
        get 'edit', params: { id: @question.id,problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      it '@questionに要求されたユーザーを割り当てること' do
        expect(assigns(:question)).to eq @question
      end
      it ':editテンプレートを表示すること' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'Get #show' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @question = create(:question)
        get 'show', params: { id: @question.id,problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 302
      end
      it ':editテンプレートを表示すること' do
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者ログイン時" do
      before do
        @user = create(:user)
        log_in_as(@user)
        @problem = create(:problem)
        @question = create(:question)
        get 'show', params: { id: @question.id,problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      it '@questionに要求されたユーザーを割り当てること' do
        expect(assigns(:question)).to eq @question
      end
      it ':editテンプレートを表示すること' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'Get #index' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @questions = create(:question)
        get 'index', params: {problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること'  do
        expect(response.status).to eq 302
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to redirect_to(root_path)
      end
    end
    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
        @questions =  create_list(:question, 2)
        get 'index', params: {problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること'  do
        expect(response.status).to eq 200
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'Get #answer_index' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @questions = create(:question)
        get 'answer_index', params: {problem_id: @problem.id}
      end
      it 'リクエストは302 となること'  do
        expect(response.status).to eq 302
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to redirect_to(root_path)
      end
    end
    context "一般ユーザーログイン時" do
      before do
        @user = create(:user)
        log_in_as(@user)
        @problem = create(:problem)
        @questions =  create_list(:question, 2)
        get 'answer_index', params: {problem_id: @problem.id}
      end
      it 'リクエストは200 OKとなること'  do
        expect(response.status).to eq 200
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :answer_index
      end
    end
  end

  describe 'Get #answer' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @question = create(:question)
        get 'answer', params: {problem_id: @problem.id, id: @question.id}
      end
      it 'リクエストは302 となること'  do
        expect(response.status).to eq 302
      end
      it ':indexテンプレートを表示すること' do
        expect(response).to redirect_to(root_path)
      end
    end
    context "一般ユーザーログイン時" do
      before do
        @user = create(:user)
        log_in_as(@user)
        @problem = create(:problem)
        @question =  create(:question)
        get 'answer', params: {problem_id: @problem.id, id: @question.id}
      end
      it 'リクエストは200 OKとなること'  do
        expect(response.status).to eq 200
      end

      it 'assigns new @question' do
        expect(assigns(:question_answer)).to be_a_new QuestionAnswer
      end

      it ':indexテンプレートを表示すること' do
        expect(response).to render_template :answer
      end
    end
  end

  describe 'GET #new' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        get :new, params: {problem_id: @problem.id}, session: {}
      end
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
        @problem = create(:problem)
        get :new, params: {problem_id: @problem.id}, session: {}
      end
      it 'has a 200 status code' do
        expect(response).to have_http_status(:ok)
      end
      it 'assigns new @question' do
        expect(assigns(:question)).to be_a_new Question
      end
      it 'renders the :new template' do
         expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @question = attributes_for(:question)
      end
      it 'saves new question' do
        expect do
          patch :create, params: { question: @question, problem_id: @problem.id}
        end.to change(@problem.questions, :count).by(0)
      end
      it 'redirects the :create template' do
        post :create, params: { question: @question, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(root_url)
      end
    end
    # context "管理者ログイン時" do
    #   before do
    #     @admin = create(:admin)
    #     log_in_as(@admin)
    #     @problem = create(:problem)
    #     @question = attributes_for(:question)
    #   end
    #   it 'saves new question' do
    #     expect do
    #       post :create, params: { question: @question, problem_id: @problem.id}
    #     end.to change(@problem.questions, :count).by(1)
    #   end
    #   it 'redirects the :create template' do
    #     post :create, params: { question: @question, problem_id: @problem.id}, session: {}
    #     expect(response).to redirect_to(problem_questions_url)
    #   end
    # end
    context "管理者ログイン時（記述式）" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
      end
      let(:problem_attributes) do
        {
          "questions_attributes"=>
            {
              "1"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japaneseexample"=> "これは、本です",
                "englishexample"=> "This is a book",
                "_destroy"=> "false"
              }
            }
        }
      end
      it 'saves new question' do
        expect do
          patch :create, params: {problem: problem_attributes, problem_id: @problem.id }
        end.to change(@problem.questions, :count).by(1)
      end
      it 'redirects the :create template' do
        patch :create, params: {problem: problem_attributes, problem_id: @problem.id }, session: {}
        expect(response).to redirect_to(problem_questions_url)
      end
    end
    context "管理者ログイン時（選択式）" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem2)
      end
      let(:problem_attributes) do
        {
          "questions_attributes"=>
            {
              "1"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "question_choices_attributes"=>{
            			"0"=>
              			{
                      "content"=>"aaaa",
              		 	  "_destroy"=>"false"
              			},
            	 	},
                "japaneseexample"=> "これは、本です",
                "englishexample"=> "This is a book",
                "_destroy"=> "false"
              }
            }
        }
      end
      it 'saves new question' do
        expect do
          post :create, params: {problem: problem_attributes, problem_id: @problem.id}
        end.to change(@problem.questions, :count).by(1).and change(QuestionChoice, :count).by(1)
      end
      it 'redirects the :create template' do
        post :create, params: {problem: problem_attributes, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(problem_questions_url)
      end
    end
  end

  describe 'PACHT #update_all' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
      end
      let(:problem_attributes) do
        {
          "questions_attributes"=>
            {
              "1"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japanseexample"=> "これは、本です",
                "englishexample"=> "This is a book",
                "_destroy"=> "false"
              },
              "2"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japanseexample"=> "これは、本です",
                "englishexample"=> "This is a book",
                "_destroy"=> "false"
              }
            }
        }
      end
      it 'redirects the :update_all template' do
        patch :update_all, params: {problem: problem_attributes, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(root_url)
      end
    end
    context "管理者ログイン時（記述式）" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
        @question = create(:question, problem_id: @problem.id)
        @question2 = create(:question, problem_id: @problem.id)
      end
      let(:problem_attributes) do
        {
          "questions_attributes"=>
            {
              "0"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japanseexample"=> "これは、本です",
                "englishexample"=> "This is a book",
                "_destroy"=> "false",
                "id" => @question.id
              },
              "1"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japanseexample"=> "これは、本です",
                "englishexample"=> "This is a book",
                "_destroy"=> "false",
                "id" => @question2.id
              }
            }
        }
      end
      it 'saves update_all question' do
        expect do
          patch :update_all, params: {problem: problem_attributes, problem_id: @problem.id }, session: {}
        end.to change(@problem.questions, :count).by(0)
      end

      it 'saves update_all question' do
        expect do
          patch :update_all, params: {problem: problem_attributes, problem_id: @problem.id}, session: {}
          @question.reload
          expect(@question.content).not_to eq problem_attributes["0"]["content"]
          expect(@question.answer).not_to eq problem_attributes["0"]["answer"]
          expect(@question.description).not_to eq problem_attributes["0"]["description"]
          @question2.reload
          expect(@question2.content).not_to eq problem_attributes["1"]["content"]
          expect(@question2.answer).not_to eq problem_attributes["1"]["answer"]
          expect(@question2.description).not_to eq problem_attributes["1"]["description"]
        end
      end

      it 'redirects the :update_all template' do
        patch :update_all, params: {problem: problem_attributes, problem_id: @problem.id }, session: {}
        expect(response).to redirect_to(problem_questions_url)
      end
    end

    context "管理者ログイン時（選択式）" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem2)
        @question = create(:question, problem_id: @problem.id)
        @question2 = create(:question, problem_id: @problem.id)
        @choice = create(:question_choice,question_id: @question.id)
        @choice2 = create(:question_choice,question_id: @question2.id)
      end
      let(:problem_attributes) do
        {
          "questions_attributes"=>
            {
              "0"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japanseexample"=> "これは、私の本です",
                "englishexample"=> "This is my book",
                "_destroy"=> "false",
                "id" => @question.id,
                "question_choices_attributes"=>{
                  "0"=>
                    {
                      "content"=>"aaaa",
                      "_destroy"=>"false"
                    },
                  "1"=>
                    {
                      "content"=>"bbbb",
                      "_destroy"=>"false"
                    },
                },
              },
              "1"=>
              {
                "problem_id"=> @problem.id,
                "content"=> "aaaa",
                "answer"=> "aaaa",
                "japanseexample"=> "これは、私の本です",
                "englishexample"=> "This is my book",
                "_destroy"=> "false",
                "id" => @question2.id,
                "question_choices_attributes"=>{
                  "0"=>
                    {
                      "content"=>"aaaa",
                      "_destroy"=>"false"
                    },
                  "1"=>
                    {
                      "content"=>"bbbb",
                      "_destroy"=>"false"
                    },
                },
              }
            }
          }
      end
      it 'saves update_all question' do
        expect do
          post :update_all, params: {problem: problem_attributes, problem_id: @problem.id}
        end.to change(@problem.questions, :count).by(0)
      end

      it 'saves update_all question' do
        expect do
          patch :update_all, params: {problem: problem_attributes, problem_id: @problem.id}, session: {}
          @question.reload
          expect(@question.content).not_to eq problem_attributes["0"]["content"]
          expect(@question.answer).not_to eq problem_attributes["0"]["answer"]
          expect(@question.japaneseexample).not_to eq problem_attributes["0"]["japaneseexample"]
          expect(@question.englishexample).not_to eq problem_attributes["0"]["englishexample"]
          @question2.reload
          expect(@question2.content).not_to eq problem_attributes["1"]["content"]
          expect(@question2.answer).not_to eq problem_attributes["1"]["answer"]
          expect(@question.japaneseexample).not_to eq problem_attributes["1"]["japaneseexample"]
          expect(@question.englishexample).not_to eq problem_attributes["1"]["englishexample"]
          @choice.reload
          expect(@choice.content).to eq update_attributes["question_choices_attributes"]["0"]["content"]
          @choice2.reload
          expect(@choice2.content).to eq update_attributes["question_choices_attributes"]["1"]["content"]
        end
      end

      it 'redirects the :create template' do
        post :create, params: {problem: problem_attributes, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(problem_questions_url)
      end
    end
  end

  describe 'PATCH #update' do
    context "未ログイン時" do
      before do
        @problem = create(:problem)
        @question = create(:question)
      end
      let(:update_attributes) do
        {
          content: 'update title',
          answer: 'update title',
          japanseexample: "これは、私の本です",
          englishexample: "This is my book"
        }
      end
      it 'saves updated question' do
        expect do
          patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id }, session: {}
        end.to change(Question, :count).by(0)
      end
      it 'updates updated question' do
        patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id}, session: {}
        @question.reload
        expect(@question.content).not_to eq update_attributes[:content]
        expect(@question.answer).not_to eq update_attributes[:answer]
        expect(@question.japaneseexample).not_to eq update_attributes[:japaneseexample]
        expect(@question.englishexample).not_to eq update_attributes[:englishexample]
      end

      it 'redirects the :create template' do
        patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
    context "管理者ログイン時 記述式" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
        @question = create(:question)
      end
      let(:update_attributes) do
        {
          content: 'update title',
          answer: 'update title',
          japaneseexample: "これは、私の本です",
          englishexample: "This is my book"
        }
      end
      it 'saves updated question' do
        expect do
          patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id }, session: {}
        end.to change(Question, :count).by(0)
      end

      it 'updates updated question' do
        patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id}, session: {}
        @question.reload
        expect(@question.content).to eq update_attributes[:content]
        expect(@question.answer).to eq update_attributes[:answer]
        expect(@question.japaneseexample).to eq update_attributes[:japaneseexample]
        expect(@question.englishexample).to eq update_attributes[:englishexample]
      end

      it 'redirects the :create template' do
        patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(problem_questions_path)
      end
    end

    context "管理者ログイン時 選択式" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem2)
        @question = create(:question)
        @choice = create(:question_choice,question_id: @question.id)
      end
      let(:update_attributes) do
        {
          content: 'update title',
          answer: 'update title',
          japaneseexample: "これは、私の本です",
          englishexample: "This is my book",
          "question_choices_attributes"=>{
            "1"=>
              {
                "content" => "aaaa",
                "_destroy" => "false",
                "id" => @question.id,
              },
          },
        }
      end
      it 'saves updated question' do
        expect do
          patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id }, session: {}
        end.to change(Question, :count).by(0).and change(QuestionChoice, :count).by(0)
      end

      it 'updates updated question' do
        patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id}, session: {}
        @question.reload
        expect(@question.content).to eq update_attributes[:content]
        expect(@question.answer).to eq update_attributes[:answer]
        expect(@question.japaneseexample).to eq update_attributes[:japaneseexample]
        expect(@question.englishexample).to eq update_attributes[:englishexample]
        @choice.reload
        expect(@choice.content).to eq update_attributes["question_choices_attributes"]["1"]["content"]
      end

      it 'redirects the :create template' do
        patch :update, params: { id: @question.id, question: update_attributes, problem_id: @problem.id}, session: {}
        expect(response).to redirect_to(problem_questions_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context "管理者ログイン時" do
      before do
        @problem = create(:problem)
        @question = create(:question)
      end
      it 'deletes the article' do
        expect do
          delete :destroy, params: { id: @question.id,problem_id: @problem.id }, session: {}
        end.to change(Question, :count).by(0)
      end

      it 'redirects the :create template' do
        delete :destroy, params: { id: @question.id,problem_id: @problem.id }, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
    context "管理者ログイン時" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @problem = create(:problem)
        @question = create(:question)
      end
      it 'deletes the article' do
        expect do
          delete :destroy, params: { id: @question.id,problem_id: @problem.id }, session: {}
        end.to change(Question, :count).by(-1)
      end
      it 'redirects the :create template' do
        delete :destroy, params: { id: @question.id,problem_id: @problem.id }, session: {}
        expect(response).to redirect_to(problem_questions_path)
      end
    end
  end
end
