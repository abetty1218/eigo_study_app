require 'rails_helper'
RSpec.describe User, type: :model do


  it "is valid with name, email, and password and email_check" do
      user = build(:user)
      expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user,name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "is invalid without a email_check" do
    user = build(:user,check: nil)
    user.valid?
    expect(user.errors[:check]).to include("を入力してください")
  end

  it "is invalid without a email" do
    user = build(:user,email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is invalid without a password" do
    user = build(:user,password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "is invalid a password smaller than 6 letters" do
    user = build(:user,password: "aaaaa")
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end

  it "is invalid with a duplicate email address" do
    User.create(
        name: "Aaron",
        email:      "tester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze",
        check: "メールをうけとる"
      )

      user = User.new(
        name: "Aaron",
        email:      "tester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze",
        check: "メールをうけとる"
      )
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
   end

end
