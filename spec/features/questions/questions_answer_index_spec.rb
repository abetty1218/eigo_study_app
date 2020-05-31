require 'rails_helper'
RSpec.feature "QuestionsAnswerIndex", type: :feature do
  before do
    @problem = create(:problem1)
    # @questions = create_list(:question,5,problem_id: @problem.id)
    @question = create(:question,problem_id: @problem.id)
    @user = create(:user)
    @answer = create(:question_answer,problem_id: @problem.id,question_id: @question.id,user_id: @user.id)
    visit login_path
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード", with: @user.password
    click_button "ログイン"
    click_link "問題"
    visit problems_path
    click_link "質問回答一覧"
    visit answer_index_problem_questions_path(@problem)
  end

  scenario "questions index" do
    expect(Question.count).to eq 1
  end

  scenario "list each question answer" do
    expect(current_path).to eq answer_index_problem_questions_path(@problem)
    expect(page).to have_title "質問回答一覧 | 英単語学習アプリ"
    expect(page).to have_css("h1", text: "質問回答一覧")
    Question.all.each do |question|
      expect(page).to have_css("td", text: question.content)
      expect(page).to have_css("td", text: question.answer)
      expect(page).to have_css("td", text: "正解")
    end
  end
end
