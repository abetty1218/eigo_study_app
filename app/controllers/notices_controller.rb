class NoticesController < ApplicationController

  before_action :logged_in_admin, only: [:new,:create,:edit,:update,:destroy]

  def new
    @notice = Notice.new
  end

  def index
    @notices = Notice.paginate(page: params[:page], per_page: 10).order(id: :desc)
  end

  def create
    @notice = Notice.new(notice_params)
    @users = User.where(check:"mail")
    if @notice.save
      @users.each do |user|
        NoticeMailer.send_notice(user).deliver
      end
      redirect_to notices_url
    else
      render 'new'
    end
  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def destroy
    @notice = Notice.find(params[:id])
    if @notice.destroy
      flash[:success] = "お知らせを削除しました。"
      redirect_to notices_url
    end
  end

  def update
    @notice = Notice.find(params[:id])
    if @notice.update_attributes(notice_params)
      flash[:success] = "お知らせを更新しました。"
      redirect_to notices_url
    else
      render "edit"
    end
  end

  private
    def notice_params
      params.require(:notice).permit(:title, :description)
    end

end
