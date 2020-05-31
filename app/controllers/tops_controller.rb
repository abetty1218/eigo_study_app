class TopsController < ApplicationController

  def home
    @notices = Notice.order(id: :desc).limit(5)
    # render plain: current_user.inspect
  end

end
