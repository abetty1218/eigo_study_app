require 'rails_helper'
RSpec.feature "UsersIndex", type: :feature do
  before do
    @users = create_list(:user, 30)
    @admin = create(:admin)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
  end

  scenario "users index count" do
    expect(User.count).to eq @users.count + 1
  end
      # ページネーションでユーザが表示されること
  scenario "list each user" do
    click_link "ユーザー一覧"
    expect(current_path).to eq users_path
    expect(page).to have_title "ユーザー一覧 | 英単語学習アプリ"
    expect(page).to have_css("h1", text: "ユーザー一覧")
    User.paginate(page: 1).each do |user|
      expect(page).to have_css("td", text: user.name)
    end
  end
end
