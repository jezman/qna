require 'rails_helper'

RSpec.shared_examples_for 'likable' do
  let(:model) { described_class }
  let(:author) { create(:user) }
  let(:liker) { create(:user) }
  let(:second_liker) { create(:user) }

  let(:likable) do
    if model.to_s == 'Answer'
      question = create(:question, user: author)
      create(model.to_s.underscore.to_sym, question: question, user: author)
    else
      create(model.to_s.underscore.to_sym, user: author)
    end
  end

  it '#vote_up' do
    likable.vote_up(liker)
    expect(Like.last.rating).to eq 1
    expect(Like.last.user).to eq liker
    expect(Like.last.likable).to eq likable
  end

  it '#vote_down' do
    likable.vote_down(liker)
    expect(Like.last.rating).to eq -1
    expect(Like.last.user).to eq liker
    expect(Like.last.likable).to eq likable
  end

  it '#rating_sum' do
    likable.vote_up(liker)
    likable.vote_up(second_liker)
    expect(likable.rating_sum).to eq 2
  end

  describe '#liked?' do
    before { likable.vote_up(liker) }

    it 'resource already user liked' do
      expect(likable).to be_liked(liker)
    end

    it 'resource has no user like' do
      expect(likable).to_not be_liked(author)
    end
  end
end
