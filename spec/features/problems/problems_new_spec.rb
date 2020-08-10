require 'rails_helper'

RSpec.feature "ProblemsNews", type: :feature do
  before do
    # @problem = create(:problem)
    # @question = create(:question,problem_id: @problem.id)
    @admin = create(:admin)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
    click_link "問題"
    visit problems_path
  end

  feature "記述式" do
    before do
      click_link "問題（記述式）作成"
      visit new_problem_path(question_style:2)
    end
    feature "valid create problem" do
      before do
        find("input[name='problem[questions_attributes][0][content]']").set("aaaa")
        find("input[name='problem[questions_attributes][0][answer]']").set("aaaa")
        find("input[name='problem[questions_attributes][0][japaneseexample]']").set("これは、本です")
        find("input[name='problem[questions_attributes][0][englishexample]']").set("This is a book")
      end

      scenario "add questions count" do
        expect { click_button '作成' }.to change { Problem.all.size }.by(1).and change{ Question.all.size }.by(1)
      end
  #
      scenario "show flash message" do
        click_button "作成"
        visit problems_path
      end
    end

    feature "invalid create problem" do
      before do
        find("input[name='problem[questions_attributes][0][content]']").set("")
        find("input[name='problem[questions_attributes][0][answer]']").set("")
        find("input[name='problem[questions_attributes][0][japaneseexample]']").set("")
        find("input[name='problem[questions_attributes][0][englishexample]']").set("")
      end

      scenario "no difference problems count" do
        expect { click_button '作成' }.to change { Problem.all.size }.by(0).and change{ Question.all.size }.by(0)
      end

      scenario "is show error messages" do
        click_button "作成"
        expect(page).to have_content "問題を入力してください"
        expect(page).to have_content "解答を入力してください"
        expect(page).to have_content "例文を入力してください"
        expect(page).to have_content "和訳を入力してください"
      end
    end
  end

  feature "選択式" do
    before do
      click_link "問題（選択式）作成"
      visit new_problem_path(question_style:1)
    end
    feature "valid new information" do
      before do
        find("input[name='problem[questions_attributes][0][content]']").set("ああああ")
        find("input[name='problem[questions_attributes][0][question_choices_attributes][0][choice]']").set(true)
        find("input[name='problem[questions_attributes][0][question_choices_attributes][0][content]']").set("ssssss")
        find("input[name='problem[questions_attributes][0][japaneseexample]']").set("これは、本です")
        find("input[name='problem[questions_attributes][0][englishexample]']").set("This is a book")
      end

      scenario "add questions count" do
        expect { click_button '作成' }.to change { Problem.all.size }.by(1).and change(Question, :count).by(1).and change(QuestionChoice, :count).by(1)
      end
  #
      scenario "show flash message" do
        click_button "作成"
        visit problems_path
      end
    end

    feature "invalid signup information" do
      before do
        find("input[name='problem[questions_attributes][0][content]']").set("")
        find("input[name='problem[questions_attributes][0][question_choices_attributes][0][choice]']").set(true)
        find("input[name='problem[questions_attributes][0][question_choices_attributes][0][content]']").set("")
        find("input[name='problem[questions_attributes][0][japaneseexample]']").set("")
        find("input[name='problem[questions_attributes][0][englishexample]']").set("")
      end

      scenario "no difference users count" do
        expect { click_button '作成' }.to change { Problem.all.size }.by(0).and change{ Question.all.size }.by(0).and change(QuestionChoice, :count).by(0)
      end

      scenario "is show error messages" do
        click_button "作成"
        expect(page).to have_content "問題を入力してください"
        expect(page).to have_content "選択欄を入力してください"
        expect(page).to have_content "例文を入力してください"
        expect(page).to have_content "和訳を入力してください"
      end
    end
  end
end
