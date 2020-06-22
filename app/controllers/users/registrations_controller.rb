# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :logged_not_in, only: [:new]
  before_action :logged_in, only: [:edit,:update]
  before_action :logged_in_admin, only: [:index,:destroy]
  before_action :correct_user, only: [:edit,:update]

  def index
    @search = params[:search]
    if User.search(@search).present? && @search != ""
      @users = User.search(@search).paginate(page: params[:page], per_page: 20).order(id: :asc)
    else
      flash[:danger] = "該当するユーザーが存在しませんでした。"
      redirect_to users_url
    end
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    self.resource = resource_class.to_adapter.get!(params[:id])
    # @user = User.find(params[:id])
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(params[:id])
    if update_resource(resource, account_update_params)
      set_flash_message :notice, :updated
      redirect_to edit_user_url(resource)
    else
      clean_up_passwords(resource)
      render :edit
    end
  end

  # DELETE /resource
  def destroy
    self.resource = resource_class.to_adapter.get!(params[:id])
    resource.destroy
    set_flash_message :notice, :destroyed
    redirect_to users_url
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  protected
    # 追記する
    def update_resource(resource, params)
      resource.update_without_current_password(params)
    end
   # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless current_user.admin == true
        unless current_user?(@user)
          flash[:danger] ="他のユーザーのサイトにはアクセスできません。"
          redirect_to root_url
        end
      end
    end

end
