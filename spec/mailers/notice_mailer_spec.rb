require "rails_helper"

RSpec.describe NoticeMailer, type: :mailer do
  describe "notice_email" do
    let(:user) { create(:user1) }
    let(:mail) { NoticeMailer.send_notice(user) }

    it "sends an email" do
      expect do
        mail.deliver_now
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "sends an email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it "sends from the support email address" do
      expect(mail.from).to eq ["from@example.com"]
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq "新着お知らせの通知"
    end

    it "greets sentence" do
      expect(mail.body).to match(/お知らせを更新しました。/)
    end

    it "greets sentence" do
      expect(mail.body).to match(/詳細はホームページをご確認ください。/)
    end

    it "greets user name" do
      expect(mail.body).to match user.name
    end
  end
end
