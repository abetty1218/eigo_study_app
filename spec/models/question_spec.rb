require 'rails_helper'
RSpec.describe Question, type: :model do

  it "is valid with content,answer,and description" do
    question = build(:question)
    expect(question).to be_valid
  end

  it "is invalid without a content" do
    question = build(:question,content: nil)
    question.valid?
    expect(question.errors[:content]).to include("を入力してください")
  end

  it "is invalid a content larger than 20 letters" do
    question = build(:question,content: "aaaaaaaaaaaaaaaaaaaaa")
    question.valid?
    expect(question.errors[:content]).to include("は20桁以内で入力してください")
  end

  it "is invalid without a answer" do
    question = build(:question,answer: nil)
    question.valid?
    expect(question.errors[:answer]).to include("を入力してください")
  end

  it "is invalid without a description" do
    question = build(:question,description: nil)
    question.valid?
    expect(question.errors[:description]).to include("を入力してください")
  end

  it "is invalid a description larger than 255 letters" do
    question = build(:question,description: "a"*256)
    question.valid?
    expect(question.errors[:description]).to include("は255桁以内で入力してください")
  end
end
