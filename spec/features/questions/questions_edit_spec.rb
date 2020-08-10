require 'rails_helper'

RSpec.feature "QuestionsEdit", type: :feature do
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
      click_link "編集"
      visit edit_problem_question_path(@problem,@question)
    end
    # ユーザーは編集に成功する
    scenario "successful edit" do
      find("input[name='question[content]']").set("あああ")
      find("input[name='question[answer]']").set("あああ")
      find("input[name='question[japaneseexample]']").set("これは、本です")
      find("input[name='question[englishexample]']").set("This is a book")
      click_button "更新"
      expect(current_path).to eq problem_questions_path(@problem)
      expect(@question.reload.content).to eq "あああ"
    end

    # ユーザーは編集に失敗する
    scenario "unsuccessful edit" do
      find("input[name='question[content]']").set("")
      find("input[name='question[answer]']").set("あああ")
      find("input[name='question[japaneseexample]']").set("これは、本です")
      find("input[name='question[englishexample]']").set("This is a book")
      click_button "更新"
      expect(@question.reload.content).to_not eq "あああ"
    end
  end

  feature "選択式" do
    before do
      @problem = create(:problem2)
      @question = create(:question,problem_id: @problem.id)
      @choice = create(:question_choice ,question_id: @question.id)
      @choice2 = create(:question_choice2, question_id: @question.id)
      @choice3 = create(:question_choice3, question_id: @question.id)
      @choice4 = create(:question_choice4, question_id: @question.id)
      click_link "問題"
      visit problems_path
      click_link "質問一覧"
      visit problem_questions_path(@problem)
      click_link "編集"
      visit edit_problem_question_path(@problem,@question)
    end

    scenario "successful edit" do
      find("input[name='question[content]']").set("ああああ")
      find("input[name='question[question_choices_attributes][1][choice]']").set(true)
      find("input[name='question[question_choices_attributes][1][content]']").set("ssssss")
      find("input[name='question[japaneseexample]']").set("これは、本です")
      find("input[name='question[englishexample]']").set("This is a book")
      click_button "更新"
      expect(@choice2.reload.choice).to eq true
      expect(@choice.reload.choice).to eq false
      expect(@choice2.reload.content).to eq "ssssss"
    end

    scenario "unsuccessful edit" do
      find("input[name='question[content]']").set("ああああ")
      find("input[name='question[question_choices_attributes][1][choice]']").set(true)
      find("input[name='question[question_choices_attributes][1][content]']").set("")
      find("input[name='question[japaneseexample]']").set("これは、本です")
      find("input[name='question[englishexample]']").set("This is a book")
      click_button "更新"
      expect(@choice2.reload.choice).to eq false
    end
  end
end
