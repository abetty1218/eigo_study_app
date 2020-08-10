require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do

  context "ユーザーログイン時" do
    before do
      @problem = create(:problem)
      @user = create(:user)
      log_in_as(@user)
    end
    it "sessions/newにアクセスできないこと" do
      get :new
      expect(response.status).to eq(302)
    end
    it "sessions/newにアクセスできないこと" do
      get :new
      expect(response).to redirect_to(root_url)
    end
    it "ログインできないこと" do
      post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
      expect(response.status).to eq(302)
    end
    it "トップ画面に遷移すること" do
      post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
      expect(response).to redirect_to(root_url)
    end
  end

  context "未ログイン時" do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end
    it "sessions/newにアクセスできること" do
      get :new
      expect(response.status).to eq(200)
    end
    it "ログインができること" do
      post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
      expect(response.status).to eq(200)
    end
  end

   #ログアウト
  describe "<request#destory>" do
    before do
      @user = create(:user)
      log_in_as(@user)
    end

    context "ユーザーがログアウトした時" do
      it "falseを返すこと" do
        delete :destroy
        expect(session[:user_id]).to be_falsey
      end
    end
  end
end
