require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        mock_oauth(:github, user.email)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context 'user with temp email' do
      let!(:user) { create(:user, email: User::TEMPORARY_EMAIL) }

      before do
        mock_oauth(:github, User::TEMPORARY_EMAIL)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to set email path' do
        expect(response).to redirect_to set_email_user_path(user)
      end
    end

    context 'user with realy email' do
      let!(:user) { create(:user) }

      before do
        mock_oauth(:github, user.email)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'vkontakte' do
    let(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        mock_oauth(:github, user.email)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context 'user with temp email' do
      let!(:user) { create(:user, email: User::TEMPORARY_EMAIL) }

      before do
        mock_oauth(:vkontakte, User::TEMPORARY_EMAIL)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to set email path' do
        expect(response).to redirect_to set_email_user_path(user)
      end
    end

    context 'user with realy email' do
      let!(:user) { create(:user) }

      before do
        mock_oauth(:vkontakte, user.email)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
