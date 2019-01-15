require 'rails_helper'

RSpec.shared_examples 'liked' do
  let(:liker) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  describe 'POST #vote_up' do
    context 'current user is author of resource' do
      before { login(liker) }

      let!(:user_likable) { liked(model, liker) }

      it 'try to add new like' do
        expect { post :vote_up, params: { id: user_likable } }.to change(Like, :count)
      end
    end
  end
end
