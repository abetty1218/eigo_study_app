class ProblemsController < ApplicationController

  def index
    @problems = Problem.all
    @problem = Problem.new
    @count = @problems.count
  end


  def released
    @problem = Problem.find(params[:id])
    if @problem.released == true
      @problem.released = false
      @problem.released_on = nil
    else
      @problem.released = true
      @problem.released_on = Date.current
    end
    if @problem.save
      flash[:success] = "公開状況を変更しました。"
      redirect_to problems_url
    else
      @problems = Problem.all
      @count = @problems.count
      render 'index'
    end
  end


  def destroy
    @problem = Problem.find(params[:id])
    @problem = Problem.find(params[:id])
    number = @problem.number
    if @problem.destroy
      @problems = Problem.where("number > ?", number)
      @problems.each do |problem|
        problem.number = problem.number - 1
        problem.save
      end
      flash[:success] = "問題を削除しました。"
      redirect_to problems_url
    end
  end
end
