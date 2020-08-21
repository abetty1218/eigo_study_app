require 'rails_helper'
RSpec.describe QuestionAnswer, type: :model do

it "is valid with content,answer,and description" do
  answer = build(:question_answer)
  expect(answer).to be_valid
end

it "is invalid without a answer" do
  answer = build(:question_answer,answer: nil)
  answer.valid?
  expect(answer.errors[:answer]).to include("を入力してください")
end

it "is invalid a content larger than 20 letters" do
  answer = build(:question_answer,answer: "aaaaaaaaaaaaaaaaaaaaa")
  answer.valid?
  expect(answer.errors[:answer]).to include("は20文字以内で入力してください")
end

end
