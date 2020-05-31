require 'rails_helper'
RSpec.feature "QuestionsIndex", type: :feature do
  before do
    @problem = create(:problem)
    @questions = create_list(:question, 30,problem_id: @problem.id)
    @admin = create(:admin)
    visit login_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
    click_link "問題"
    visit problems_path
  end

  scenario "questions index" do
    expect(Question.count).to eq @questions.count
  end
      # ページネーションでユーザが表示されること
  scenario "list each user" do
    click_link "質問一覧"
    expect(current_path).to eq problem_questions_path(@problem)
    expect(page).to have_title "質問一覧 | 英単語学習アプリ"
    expect(page).to have_css("h1", text: "質問一覧")
    Question.all.each do |question|
      expect(page).to have_css("td", text: question.content)
      expect(page).to have_css("td", text: question.answer)
    end
  end
end
