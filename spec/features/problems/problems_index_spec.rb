require 'rails_helper'

RSpec.feature "ProblemsIndex", type: :feature do
  before do
    @problems = create_list(:problem, 5)
    @problems.each do |problem|
      @question = create(:question,problem_id: problem.id)
    end
    @admin = create(:admin)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
    click_link "問題"
    visit problems_path

  end

  scenario "problems index" do
    expect(Problem.count).to eq @problems.count
  end
      # ページネーションでユーザが表示されること
  scenario "list each problem" do
    expect(current_path).to eq problems_path
    expect(page).to have_title "問題一覧 | 英単語学習アプリ"
    expect(page).to have_css("h1", text: "問題一覧")
    Problem.all.each do |problem|
      expect(page).to have_css("td", text: problem.number)
    end
  end
end
