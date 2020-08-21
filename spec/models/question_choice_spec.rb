RSpec.describe QuestionChoice, type: :model do

  it "is valid with content,number" do
    choice = build(:question_choice)
    expect(choice).to be_valid
  end

  it "is invalid without a content" do
    choice = build(:question_choice,content: nil)
    choice.valid?
    expect(choice.errors[:content]).to include("を入力してください")
  end

  it "is invalid a content larger than 20 letters" do
    choice = build(:question_choice,content: "aaaaaaaaaaaaaaaaaaaaa")
    choice.valid?
    expect(choice.errors[:content]).to include("は20文字以内で入力してください")
  end

end
