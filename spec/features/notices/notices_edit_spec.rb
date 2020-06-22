require 'rails_helper'

RSpec.feature "NoticesEdit", type: :feature do
  before do
    @notice = create(:notice)
    @admin = create(:admin)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"

    click_link "お知らせ一覧へ"
    visit notices_path

    click_link "編集"
    visit edit_notice_path(@notice)

  end

  feature "valid notice update" do
    before do
      fill_in "タイトル", with: "ああああ"
      fill_in "詳細", with: "ああああああ"
    end

    scenario "add notices count" do
      click_button "更新"
      expect(current_path).to eq notices_path
      expect(@notice.reload.title).to eq "ああああ"
    end

  end

  feature "invalid notice update" do
    before do
      fill_in "タイトル", with: ""
      fill_in "詳細", with: ""
    end

    scenario "is show error messages" do
      click_button "更新"
      expect(@notice.reload.title).to_not eq "ああああ"
    end
  end
end
