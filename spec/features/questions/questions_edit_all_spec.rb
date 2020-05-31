require 'rails_helper'

RSpec.feature "QuestionsEdit", type: :feature do
  before do
    @admin = create(:admin)
    visit login_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
  end

  feature "記述式" do
    before do
      @problem = create(:problem)
      @question = create(:question,problem_id: @problem.id)
      @question2 = create(:question,problem_id: @problem.id)
      click_link "問題"
      visit problems_path
      click_link "質問一覧"
      visit problem_questions_path(@problem)
      click_link "質問一括編集"
    end
    # ユーザーは編集に成功する
    scenario "successful edit" do
      find("input[name='problem[questions_attributes][0][content]']").set("aaaa")
      find("input[name='problem[questions_attributes][0][answer]']").set("aaaa")
      find("textarea[name='problem[questions_attributes][0][description]']").set("aaaa")
      find("input[name='problem[questions_attributes][1][content]']").set("aaaa")
      find("input[name='problem[questions_attributes][1][answer]']").set("aaaa")
      find("textarea[name='problem[questions_attributes][1][description]']").set("aaaa")
      click_button "更新"
      expect(current_path).to eq problem_questions_path(@problem)
      expect(@question.reload.content).to eq "aaaa"
      expect(@question2.reload.content).to eq "aaaa"
    end

    # ユーザーは編集に失敗する
    scenario "unsuccessful edit" do
      find("input[name='problem[questions_attributes][0][content]']").set("")
      find("input[name='problem[questions_attributes][0][answer]']").set("aaaa")
      find("textarea[name='problem[questions_attributes][0][description]']").set("aaaa")
      click_button "更新"
      expect(@question.reload.content).to_not eq "ああああ"
    end
  end
  #
  feature "選択式" do
    before do
      @problem = create(:problem2)
      @question = create(:question,problem_id: @problem.id)
      @question2 = create(:question,problem_id: @problem.id)
      @choice = create(:question_choice ,question_id: @question.id)
      @choice2 = create(:question_choice2, question_id: @question.id)
      @choice3 = create(:question_choice3, question_id: @question2.id)
      @choice4 = create(:question_choice4, question_id: @question2.id)
      click_link "問題"
      visit problems_path
      click_link "質問一覧"
      visit problem_questions_path(@problem)
      click_link "質問一括編集"
    end

    scenario "successful edit" do
      find("input[name='problem[questions_attributes][0][content]']").set("aaaa")
      find("input[name='problem[questions_attributes][0][question_choices_attributes][1][choice]']").set(true)
      find("input[name='problem[questions_attributes][0][question_choices_attributes][1][content]']").set("ssssss")
      find("textarea[name='problem[questions_attributes][0][description]']").set("aaaa")
      find("input[name='problem[questions_attributes][1][content]']").set("aaaa")
      find("input[name='problem[questions_attributes][1][question_choices_attributes][1][choice]']").set(true)
      find("input[name='problem[questions_attributes][1][question_choices_attributes][1][content]']").set("ssssss")
      find("textarea[name='problem[questions_attributes][1][description]']").set("aaaa")
      click_button "更新"
      expect(@choice2.reload.choice).to eq true
      expect(@choice.reload.choice).to eq false
      expect(@choice2.reload.content).to eq "ssssss"
      expect(@choice4.reload.choice).to eq true
      expect(@choice4.reload.content).to eq "ssssss"
    end

    scenario "unsuccessful edit" do
      find("input[name='problem[questions_attributes][0][content]']").set("aaaa")
      find("input[name='problem[questions_attributes][0][question_choices_attributes][1][choice]']").set(true)
      find("input[name='problem[questions_attributes][0][question_choices_attributes][1][content]']").set("")
      find("textarea[name='problem[questions_attributes][0][description]']").set("aaaa")
      click_button "更新"
      expect(@choice2.reload.choice).to eq false
    end
  end
end
