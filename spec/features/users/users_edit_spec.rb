require 'rails_helper'

RSpec.feature "Edit", type: :feature do
  before do
    @user = create(:user)
    visit new_user_session_path
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード", with: @user.password
    click_button "ログイン"
  end

  scenario "successful edit" do
    click_link "アカウント編集"
    visit edit_user_path(@user)

    fill_in "メールアドレス", with: "edit@example.com"

    click_button "更新"

    expect(current_path).to eq edit_user_path(@user)
    expect(@user.reload.email).to eq "edit@example.com"
  end

  scenario "unsuccessful edit" do

    click_link "アカウント編集"
    visit edit_user_path(@user)

    fill_in "メールアドレス", with: "foo@invalid"
    click_button "更新"

    expect(@user.reload.email).to_not eq "foo@invalid"
  end
end
