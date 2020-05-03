require 'rails_helper'
RSpec.describe Notice, type: :model do

  it "is valid with content,notice,and description" do
    notice = build(:notice)
    expect(notice).to be_valid
  end

  it "is invalid without a title" do
    notice = build(:notice,title: nil)
    notice.valid?
    expect(notice.errors[:title]).to include("を入力してください")
  end

  it "is invalid a title larger than 100 letters" do
    notice = build(:notice,title: "a"*101)
    notice.valid?
    expect(notice.errors[:title]).to include("は100桁以内で入力してください")
  end

  it "is invalid without a description" do
    notice = build(:notice,description: nil)
    notice.valid?
    expect(notice.errors[:description]).to include("を入力してください")
  end

  it "is invalid a description larger than 255 letters" do
    notice = build(:notice,description: "a"*256)
    notice.valid?
    expect(notice.errors[:description]).to include("は255桁以内で入力してください")
  end
end
