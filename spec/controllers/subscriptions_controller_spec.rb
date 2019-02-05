require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  before { login(other_user) }

  describe 'POST #create' do
    it 'subscribe to question' do
      expect do
        post :create, params: { question_id: question }, format: :js
      end.to change(question.subscriptions, :count).by(1)
    end
  end
end
