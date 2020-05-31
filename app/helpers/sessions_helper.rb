module SessionsHelper

  def admin_logged_in?
    if(!current_user.nil?)
      current_user.admin == true
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def user_logged_in?
    if(!current_user.nil?)
      current_user.admin == nil
    end
  end

   # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

   # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

end
