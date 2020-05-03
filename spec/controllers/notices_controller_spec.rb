require 'rails_helper'
describe NoticesController do
  describe 'Get #edit' do
    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @notice = create(:notice)
        get 'edit', params: { id: @notice.id }
      end
      it 'has a 200 status code' do
        expect(response.status).to eq 200
      end
      it 'assigns the requested user to @user' do
        expect(assigns(:notice)).to eq @notice
      end
      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end
    end
    context "when no user login" do
      before do
        @notice = create(:notice)
        get 'edit', params: { id: @notice.id }
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'renders the :edit template' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'Get #index' do
    before do
      @notices = create(:notice)
      get 'index'
    end
    it 'has a 200 status code'  do
      expect(response.status).to eq 200
    end

    it 'renders the :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        get :new, params: {}, session: {}
      end
      it 'has a 200 status code' do
        expect(response.status).to eq 200
      end
      it 'assigns new @notice' do
        expect(assigns(:notice)).to be_a_new Notice
      end
      it 'renders the :new template' do
         expect(response).to render_template :new
      end
    end
    context "when no user login" do
      before do
        get :new, params: {}, session: {}
      end
      it 'has a 302 status code' do
        expect(response.status).to eq 302
      end
      it 'redirects root_path' do
         expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @notice = attributes_for(:notice)
      end
      it 'saves new notice change count' do
        expect do
          post :create, params: { notice: @notice}
        end.to change(Notice, :count).by(1)
      end

      it 'redirects the :create template' do
        post :create, params: { notice: @notice}, session: {}
        notice = Notice.last
        expect(response).to redirect_to(notices_path)
      end
    end
    context "when no user login" do
      before do
        @notice = attributes_for(:notice)
      end
      it 'no save new notice and no change count' do
        expect do
          post :create, params: { notice: @notice}
        end.to change(Notice, :count).by(0)
      end
      it 'redirects root_path' do
        post :create, params: { notice: @notice}, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:update_attributes) do
      {
          title: 'update title',
          description: 'update body'
      }
    end
    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @notice = create(:notice)
      end

      it 'no change count' do
        expect do
          patch :update, params: { id: @notice.id, notice: update_attributes }, session: {}
        end.to change(Notice, :count).by(0)
      end

      it 'updates updated notice' do
        patch :update, params: { id: @notice.id, notice: update_attributes }, session: {}
        @notice.reload
        expect(@notice.title).to eq update_attributes[:title]
        expect(@notice.description).to eq update_attributes[:description]
      end

      it 'redirects notices_path' do
        patch :update, params: { id: @notice.id, notice: update_attributes}, session: {}
        expect(response).to redirect_to(notices_path)
      end
    end
    context "when no user login" do
      before do
        @notice = create(:notice)
      end

      it 'no change count' do
        expect do
          patch :update, params: { id: @notice.id, notice: update_attributes }, session: {}
        end.to change(Notice, :count).by(0)
      end

      it 'no updates notice' do
        patch :update, params: { id: @notice.id, notice: update_attributes }, session: {}
        @notice.reload
        expect(@notice.title).not_to eq update_attributes[:title]
        expect(@notice.description).not_to eq update_attributes[:description]
      end

      it 'redirects root_path' do
        patch :update, params: { id: @notice.id, notice: update_attributes}, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when no user login" do
      before do
        @notice = create(:notice)
      end
      it 'no deletes notice no change count' do
        expect do
          delete :destroy, params: { id: @notice.id }, session: {}
        end.to change(Notice, :count).by(0)
      end

      it 'redirects root_path' do
        delete :destroy, params: { id: @notice.id }, session: {}
        expect(response).to redirect_to(root_path)
      end
    end
    context "when admin user login" do
      before do
        @admin = create(:admin)
        log_in_as(@admin)
        @notice = create(:notice)
      end
      it 'deletes notice and change count' do
        expect do
          delete :destroy, params: { id: @notice.id }, session: {}
        end.to change(Notice, :count).by(-1)
      end

      it 'redirects notices_path' do
        delete :destroy, params: { id: @notice.id }, session: {}
        expect(response).to redirect_to(notices_path)
      end
    end
  end
end
