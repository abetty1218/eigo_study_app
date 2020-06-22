class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      added_attrs = [ :email, :name, :password, :password_confirmatio, :check ]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

  include SessionsHelper

  private
   # ログイン済みユーザーかどうか確認
    def logged_in
      unless logged_in?
        flash[:danger] = "アクセス権がありません。"
        redirect_to new_user_session_url
      end
    end

    # ログイン済みの場合はアクセスできない
    def logged_not_in
      if logged_in?
        flash[:danger] = "ログイン中はアクセスできません。"
        redirect_to root_url
      end
    end

     # ログイン済み管理者ユーザーかどうか確認
    def logged_in_admin
      unless admin_logged_in?
        flash[:danger] = "アクセス権がありません。"
        redirect_to root_url
      end
    end

    # ログイン済み一般ユーザーかどうか確認
   def logged_in_user
     unless user_logged_in?
       flash[:danger] = "アクセス権がありません。"
       redirect_to root_url
     end
   end

    # ログイン済みの自分以外のユーザに入れない
    def logged_only_current_user
      if logged_in?
        if params[:user_id]
          @user = User.find(params[:user_id])
        else
          @user = User.find(params[:id])
        end
         #自分以外のユーザーでなければ
        unless current_user?(@user)
          flash[:danger] ="他のユーザーのサイトにはアクセスできません。"
          redirect_to hotels_url
        end
      end
  end

end
