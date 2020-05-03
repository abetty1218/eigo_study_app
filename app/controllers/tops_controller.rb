class TopsController < ApplicationController

  def home
    @notices = Notice.order(id: :desc).limit(5)
  end

end
