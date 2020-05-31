require 'rails_helper'
RSpec.describe Problem, type: :model do

  it "is valid with question_style,released_on,and release and number" do
    problem = build(:problem)
    expect(problem).to be_valid
  end

  it "is invalid without a question_style" do
    problem = build(:problem,question_style: nil)
    problem.valid?
    expect(problem.errors[:question_style]).to include("を入力してください")
  end

  it "is invalid without a number" do
    problem = build(:problem,number: nil)
    problem.valid?
    expect(problem.errors[:number]).to include("を入力してください")
  end

  it "is invalid with a duplicate number" do
    Problem.create(
        question_style: 2,
        released: false,
        released_on: nil,
        number: 1
      )

      problem = Problem.new(
        question_style: 2,
        released: false,
        released_on: nil,
        number: 1
      )
    problem.valid?
    expect(problem.errors[:number]).to include("はすでに存在します")
   end
end
