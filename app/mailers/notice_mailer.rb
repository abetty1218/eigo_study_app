class NoticeMailer < ApplicationMailer

  def send_notice(user) 
    @user = user
    mail to: user.email, subject:"新着お知らせの通知"
  end

end
