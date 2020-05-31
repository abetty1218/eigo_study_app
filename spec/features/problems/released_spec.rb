require 'rails_helper'

RSpec.feature "Released", type: :feature do
  before do
    @admin = create(:admin)
    visit login_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
  end

  feature "problem release false" do
    before do
      @problem = create(:problem)
      @question = create(:question,problem_id: @problem.id)
      click_link "問題"
      visit problems_path
    end
    scenario "problem" do
      expect(current_path).to eq problems_path
      expect(page).to have_title "問題一覧 | 英単語学習アプリ"
      expect(page).to have_css("h1", text: "問題一覧")
      click_link "公開"
      visit problems_path
      expect(@problem.reload.released).to eq true
      expect(@problem.reload.released_on).to eq Date.current
    end
  end
  feature "problem release true" do
    before do
      @problem = create(:problem1)
      @question = create(:question,problem_id: @problem.id)
      click_link "問題"
      visit problems_path
    end
    scenario "problem" do
      expect(current_path).to eq problems_path
      expect(page).to have_title "問題一覧 | 英単語学習アプリ"
      expect(page).to have_css("h1", text: "問題一覧")
      click_link "非公開"
      visit problems_path
      expect(@problem.reload.released).to eq false
      expect(@problem.reload.released_on).to eq nil
    end
  end
end
