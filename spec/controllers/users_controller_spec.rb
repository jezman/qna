require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user_with_realy_email) { create(:user) }
  let!(:user_with_tmp_email) { create(:user, email: User::TEMPORARY_EMAIL) }
  let(:realy_email) { 'realy@email.address' }

  describe 'GET #set_email' do
    context 'need change email' do
      it 'renders set_email' do
        login(user_with_tmp_email)
        get :set_email, params: { id: user_with_tmp_email }

        expect(response).to render_template :set_email
      end
    end

    context 'check email' do
      it 'redirects to root if email not temporary' do
        login(user_with_realy_email)
        get :set_email, params: { id: user_with_realy_email }

        expect(response.location).to match(root_path)
      end
    end
  end

  describe 'POST #confirm_email' do
    context 'need change email' do
      before { login(user_with_tmp_email) }

      it 'changes user email' do
        patch :confirm_email, params: { id: user_with_tmp_email, user: { email: realy_email }}
        user_with_tmp_email.reload

        expect(user_with_tmp_email.unconfirmed_email).to eq 'realy@email.address'
      end

      it 'renders set_email' do
        patch :confirm_email, params: { id: user_with_tmp_email, user: { email: realy_email }}

        expect(response.location).to match(set_email_user_path(user_with_tmp_email))
      end
    end

    context 'check email' do
      before { login(user_with_realy_email) }

      it 'redirects to verify user' do
        patch :confirm_email, params: { id: user_with_realy_email, user: { email: realy_email }}
        user_with_realy_email.reload

        expect(user_with_realy_email.unconfirmed_email).to_not eq realy_email
      end
    end
  end
end
