require 'rails_helper'

RSpec.feature "Login", type: :feature do
  before do
    visit new_user_registration_path
    fill_in "名前", with: "Example User"
    fill_in "メールアドレス", with: "user@example.com"
    find("input[name='user[check]'][value='mail']").set(true)
    fill_in "パスワード", with: "password"
    fill_in "パスワード再確認", with: "password"
    click_button '作成'
  end

  scenario "successfully logout" do
    click_link "ログアウト"
    expect(current_path).to eq root_path
    expect(page).to have_content "アカウント作成"
    expect(page).to have_css("a", text: "ログイン")
    expect(page).to_not have_css("a", text: "ログアウト")
    expect(page).to_not have_css("a", text: "アカウント編集")
  end
end
