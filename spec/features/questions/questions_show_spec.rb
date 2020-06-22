require 'rails_helper'
RSpec.feature "QuestionsAnswerIndex", type: :feature do
  before do
    @problem = create(:problem1)
    @question = create(:question,problem_id: @problem.id)
    @user = create(:user)
    @answer = create(:question_answer,problem_id: @problem.id,question_id: @question.id,user_id: @user.id)
    visit new_user_session_path
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード", with: @user.password
    click_button "ログイン"
    click_link "問題"
    visit problems_path
    click_link "質問回答一覧"
    visit answer_index_problem_questions_path(@problem)
    click_link "詳細"
    visit problem_question_path(@problem,@question)
  end

  scenario "list question show" do
    expect(current_path).to eq problem_question_path(@problem,@question)
    expect(page).to have_title "詳細 | 英単語学習アプリ"
    expect(page).to have_css("h1", text: "詳細")
    expect(page).to have_css("div", text: @question.content)
    expect(page).to have_css("div", text: @question.answer)
    expect(page).to have_css("div", text: @question.description)
  end
end
