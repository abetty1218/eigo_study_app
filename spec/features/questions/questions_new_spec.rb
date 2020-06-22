require 'rails_helper'

RSpec.feature "QuestionsNews", type: :feature do

  before do
    @admin = create(:admin)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
  end

  feature "記述式" do
    before do
      @problem = create(:problem)
      @question = create(:question,problem_id: @problem.id)
      click_link "問題"
      visit problems_path
      click_link "質問一覧"
      visit problem_questions_path(@problem)
      click_link "質問追加"
      visit new_problem_question_path(@problem)
    end

    feature "valid new question" do
      before do
        find("input[name='problem[questions_attributes][1][content]']").set("ああああ")
        find("input[name='problem[questions_attributes][1][answer]']").set("あああq")
        find("textarea[name='problem[questions_attributes][1][description]']").set("あああ")
      end

      scenario "add questions count" do
        expect { click_button '登録' }.to change { Question.all.size }.by(1)
      end
  #
      scenario "show flash message" do
        click_button "登録"
        visit problem_questions_path(@problem)
      end

    end
  #
    feature "invalid signup information" do
      before do
        find("input[name='problem[questions_attributes][1][content]']").set("")
        find("input[name='problem[questions_attributes][1][answer]']").set("")
        find("textarea[name='problem[questions_attributes][1][description]']").set("")
      end

      scenario "no difference users count" do
        expect { click_button '登録' }.to_not change { Question.all.size }
      end

      scenario "is show error messages" do
        click_button "登録"
        expect(page).to have_content "問題を入力してください"
        expect(page).to have_content "解答を入力してください"
        expect(page).to have_content "解説を入力してください"
      end
    end
  end

  feature "選択式" do
    before do
      @problem = create(:problem2)
      @questions =  create_list(:check_question, 2, problem_id: @problem.id)
      @choice = create(:question_choice, question_id: @questions[0].id)
      @choice2 = create(:question_choice2, question_id: @questions[0].id)
      click_link "問題"
      visit problems_path
      click_link "質問一覧"
      visit problem_questions_path(@problem)
      click_link "質問追加"
      visit new_problem_question_path(@problem)
    end

    feature "successful create" do
      before do
        find("input[name='problem[questions_attributes][2][content]']").set("ああああ")
        find("input[name='problem[questions_attributes][2][question_choices_attributes][0][choice]']").set(true)
        find("input[name='problem[questions_attributes][2][question_choices_attributes][0][content]']").set("ああああ")
        find("textarea[name='problem[questions_attributes][2][description]']").set("あああ")
      end

      scenario "add questions count" do
        expect { click_button '登録' }.to change { Question.all.size }.by(1).and change(QuestionChoice, :count).by(1)
      end

      scenario "show flash message" do
        visit problem_questions_path(@problem)
      end
    end

    feature "unsuccessful create" do
      before do
        find("input[name='problem[questions_attributes][2][content]']").set("")
        find("input[name='problem[questions_attributes][2][question_choices_attributes][0][choice]']").set(true)
        find("input[name='problem[questions_attributes][2][question_choices_attributes][0][content]']").set("")
        find("textarea[name='problem[questions_attributes][2][description]']").set("")
      end

      scenario "no difference questions and questionchoice count" do
        expect { click_button '登録' }.to_not change { Question.all.size }
        expect { click_button '登録' }.to_not change { QuestionChoice.all.size }
      end

      scenario "is show error messages" do
        click_button "登録"
        expect(page).to have_content "問題を入力してください"
        expect(page).to have_content "選択欄を入力してください"
        expect(page).to have_content "解説を入力してください"
      end
    end
  end
end
