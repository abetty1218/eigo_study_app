require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do

  context "ユーザーログイン時" do
    before do
      @problem = create(:problem)
      @user = create(:user)
      log_in_as(@user)
    end
    it "sessions/newにアクセスできること" do
      get :new
      expect(response.status).to eq(302)
    end
    it "sessions/newにアクセスできること" do
      get :new
      expect(response).to redirect_to(root_url)
    end
    it "sessions/newにアクセスできること" do
      post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
      expect(response.status).to eq(302)
    end
    it "sessions/newにアクセスできること" do
      post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
      expect(response).to redirect_to(root_url)
    end
  end

  context "未ログイン時" do
    it "sessions/newにアクセスできること" do
      get :new
      expect(response.status).to eq(200)
    end
    it "sessions/newにアクセスできること" do
      post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
      expect(response.status).to eq(200)
    end
  end

  describe "<sessions#new>" do
    context "ログインに失敗した時" do
      it "フラッシュメッセージの残留をキャッチすること" do
        get :new
        expect(response.status).to eq(200)
        post :create, params: { session: { email: "", password: "" }}
        expect(response).to have_http_status(:success)
        expect(flash[:danger]).to be_truthy
        get :new
        expect(flash[:danger]).to be_falsey
      end
    end
    context "ログインに成功した時" do
      it "フラッシュメッセージの残留をキャッチすること" do
        get :new
        expect(response.status).to eq(200)
        post :create, params: { session: { email: "tester1@example.com", password:"dottle-nouveau-pavilion-tights-furze"}}
        user = build(:user)
        log_in_as(user)
        expect(response).to have_http_status(:success)
        # expect(response).to redirect_to(timecard_path(user))
      end
    end
  end
   #ログアウト
  describe "<request#destory>" do
    before do
      @user = build(:user)
      allow(User).to receive(:find_by).and_return(@user)
    end

    context "ユーザーがログアウトした時" do
      it "falseを返すこと" do
        delete :destroy
        expect(session[:user_id]).to be_falsey
      end
    end
  end
end
