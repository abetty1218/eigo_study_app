require 'rails_helper'

RSpec.feature "NoticesNews", type: :feature do
  include ActiveJob::TestHelper

  setup do
    ActionMailer::Base.delivery_method = :test
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
  end

  before do
    @admin = create(:admin)
    @user = create(:user1)
    visit new_user_session_path
    fill_in "メールアドレス", with: @admin.email
    fill_in "パスワード", with: @admin.password
    click_button "ログイン"

    click_link "お知らせ一覧へ"
    visit notices_path

    click_link "新規登録"
    visit new_notice_path

  end

  feature "valid notice create" do
    before do
      fill_in "タイトル", with: "ああああ"
      fill_in "詳細", with: "ああああああ"
    end

    scenario "add notices count" do
      expect { click_button '登録' }.to change { Notice.all.size }.by(1)
    end

    scenario "create to redirect" do
      click_button "登録"
      visit notices_path
    end

    scenario "send email" do
      click_button "登録"
      perform_enqueued_jobs do
        mail = ActionMailer::Base.deliveries.last
        aggregate_failures do
          expect(mail.to).to eq ["test@example.com"]
          expect(mail.from).to eq ["from@example.com"]
          expect(mail.subject).to eq "新着お知らせの通知"
          expect(mail.body).to match "お知らせを更新しました。"
          expect(mail.body).to match "詳細はホームページをご確認ください。"
          expect(mail.body).to match @user.name
        end
      end

    end

  end

  feature "invalid notice create" do
    before do
      fill_in "タイトル", with: ""
      fill_in "詳細", with: ""
    end

    scenario "no difference notices count" do
      expect { click_button '登録' }.to_not change { Notice.all.size }
    end

    scenario "is show error messages" do
      click_button "登録"
      expect(page).to have_content "タイトルを入力してください"
      expect(page).to have_content "詳細を入力してください"
    end
  end
end
