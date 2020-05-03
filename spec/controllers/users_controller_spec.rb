require 'rails_helper'
describe UsersController do
#
  describe 'Get #edit' do
    context "when no user login" do
      before do
        @user = create(:user)
        get 'edit', params: { id: @user.id }
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'redirects to login_path' do
        expect(response).to redirect_to(login_path)
      end
    end
    context "when user login" do
      before do
        @user1 = create(:user)
        @user2 = create(:user)
        log_in_as(@user1)
      end
      context "when sane user" do
        before do
          get 'edit', params: { id: @user1.id }
        end
        it 'has a 200 status code' do
          expect(response.status).to eq 200
        end
        it 'assigns the requested user to @user' do
          expect(assigns(:user)).to eq @user1
        end
        it 'renders the :edit template' do
          expect(response).to render_template :edit
        end
      end
      context "when other user" do
        before do
          get 'edit', params: { id: @user2.id }
        end
        it 'has a 302 status codeと' do
          expect(response.status).to eq 302
        end
        it 'redirects root_path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'Get #index' do
    context "when user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        get 'index'
      end

      it 'has a 200 status code'  do
        expect(response.status).to eq 200
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end
    context "未ログイン時" do
      before do
        get 'index'
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'redirects root_path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #new' do
    before { get :new, params: {}, session: {} }

    it 'has a 200 status code' do
      expect(response.status).to eq 200
    end

    it 'assigns new User' do
      expect(assigns(:user)).to be_a_new User
    end

    it 'renders the :new template' do
       expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context "when user login" do
      before do
        @user = attributes_for(:user)
        @not_user = attributes_for(:user,name:nil)
      end

      context "when same user" do
        it 'saves create user change users count' do
          expect do
            post :create, params: { user: @user}
          end.to change(User, :count).by(1)
        end

        it 'redirects to root_path' do
          post :create, params: { user: @user}, session: {}
          expect(response).to redirect_to(root_path)
        end
      end
      context "when other user" do
        it 'no change users count' do
          expect do
            post :create, params: { user: @not_user}
          end.to change(User, :count).by(0)
        end

        it 'redirects the :new template' do
          post :create, params: { user: @not_user}, session: {}
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PATCH #update' do
      let(:update_attributes) do
        {
            name: 'update title',
            email: 'aaa@gmail.com'
        }
      end
    context "when no user login" do
      before do
        @user = create(:user)
      end
      it 'no change users count' do
        expect do
          patch :update, params: { id: @user.id, user: update_attributes }, session: {}
        end.to change(User, :count).by(0)
      end

      it 'no change user' do
        patch :update, params: { id: @user.id, user: update_attributes }, session: {}
        @user.reload
        expect(@user.name).not_to eq update_attributes[:name]
        expect(@user.email).not_to eq update_attributes[:email]
      end

      it 'redirects login_path' do
        patch :update, params: { id: @user.id, user: update_attributes}, session: {}
        expect(response).to redirect_to(login_path)
      end
    end

    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @user = create(:user)
      end
      it 'no change users count' do
        expect do
          patch :update, params: { id: @user.id, user: update_attributes }, session: {}
        end.to change(User, :count).by(0)
      end

      it 'change user' do
        patch :update, params: { id: @user.id, user: update_attributes }, session: {}
        @user.reload
        expect(@user.name).to eq update_attributes[:name]
        expect(@user.email).to eq update_attributes[:email]
      end

      it 'redirects edit_user_path' do
        patch :update, params: { id: @user.id, user: update_attributes}, session: {}
        user = User.last
        expect(response).to redirect_to(edit_user_path(user))
      end
    end

    context "when general user login" do
      before do
        @user2 = create(:user)
        @user1 = create(:user)
        log_in_as(@user1)
      end
      it 'no change users count' do
        expect do
          patch :update, params: { id: @user1.id, user: update_attributes }, session: {}
        end.to change(User, :count).by(0)
      end

      it 'change user' do
        patch :update, params: { id: @user1.id, user: update_attributes }, session: {}
        @user1.reload
        expect(@user1.name).to eq update_attributes[:name]
        expect(@user1.email).to eq update_attributes[:email]
      end

      it 'no change oher_user' do
        patch :update, params: { id: @user2.id, user: update_attributes }, session: {}
        @user2.reload
        expect(@user2.name).not_to eq update_attributes[:name]
        expect(@user2.email).not_to eq update_attributes[:email]
      end

      it 'redirects edit_user_path' do
        patch :update, params: { id: @user1.id, user: update_attributes}, session: {}
        user = User.last
        expect(response).to redirect_to(edit_user_path(user))
      end

      it 'redirects root_path' do
        patch :update, params: { id: @user2.id, user: update_attributes}, session: {}
        expect(response).to redirect_to(root_path)
      end
    end

  end

  describe 'DELETE #destroy' do
    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @user = create(:user)
      end
      it 'deletes the user' do
        expect do
          delete :destroy, params: { id: @user.id }, session: {}
        end.to change(User, :count).by(-1)
      end

      it 'redirects user_path' do
        delete :destroy, params: { id: @user.id }, session: {}
        expect(response).to redirect_to(users_path)
      end
    end
    context "when general user login" do
      before do
        @user= create(:user)
        log_in_as(@user)
      end
      it 'deletes the user no change users count' do
        expect do
          delete :destroy, params: { id: @user.id }, session: {}
        end.to change(User, :count).by(0)
      end

      it 'redirects root_path' do
        delete :destroy, params: { id: @user.id }, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user no login" do
      before do
        @user = create(:user)
      end
      it 'no deletes user no change users count' do
        expect do
          delete :destroy, params: { id: @user.id }, session: {}
        end.to change(User, :count).by(0)
      end
      it 'redirects root_path' do
        delete :destroy, params: { id: @user.id }, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
