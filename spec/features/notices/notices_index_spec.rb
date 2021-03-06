require 'rails_helper'
RSpec.feature "NoticesIndex", type: :feature do
  before do
    @notices = create_list(:notice, 30)
    @admin = create(:admin)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"
  end

  scenario "notice index" do
    expect(Notice.count).to eq @notices.count
  end
      # ページネーションでユーザが表示されること
  scenario "list each notice" do
    click_link "お知らせ一覧へ"
    expect(current_path).to eq notices_path
    expect(page).to have_title "お知らせ一覧 | 英単語学習アプリ"
    expect(page).to have_css("h1", text: "お知らせ一覧")
    Notice.paginate(page: 1).each do |notice|
      expect(page).to have_css("li", text: notice.title)
      expect(page).to have_css("li", text: notice.description)
    end
  end
end
