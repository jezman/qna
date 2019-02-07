require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  include ControllerHelpers

  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other) }

    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_other) { create(:answer, question: question, user: other) }
    let(:answer_other) { create(:answer, question: question_other, user: other) }

    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:comment_other) { create(:comment, commentable: question, user: other) }

    let(:link) { create(:link, linkable: question) }
    let(:link_other) { create(:link, linkable: question_other) }

    let!(:like_question) { create(:like, likable: question, user: user) }
    let!(:like_question_other) { create(:like, likable: question_other, user: other) }
    let!(:like_answer) { create(:like, likable: answer_other, user: user) }
    let!(:like_answer_other) { create(:like, likable: answer, user: other) }

    before do
      attach_file_to(question)
      attach_file_to(question_other)
    end

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, question_other }
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, question_other }

      it { should be_able_to [:vote_up, :vote_down], question_other }
      it { should_not be_able_to [:vote_up, :vote_down], question }
      it { should be_able_to :revoke, question }
      it { should_not be_able_to :revoke, question_other }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer_other }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, answer_other }
      it { should be_able_to :best, answer }
      it { should_not be_able_to :best, answer_other }

      it { should be_able_to [:vote_up, :vote_down], answer_other }
      it { should_not be_able_to [:vote_up, :vote_down], answer }
      it { should_not be_able_to :revoke, answer }
      it { should be_able_to :revoke, answer_other }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, comment }
      it { should_not be_able_to :update, comment_other }
    end

    context 'Link' do
      it { should be_able_to :destroy, link }
      it { should_not be_able_to :destroy, link_other }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, question.files.last }
      it { should_not be_able_to :destroy, question_other.files.last }
    end

    context 'User' do
      it { should be_able_to :me, User }
    end

    context 'Subscription' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, Subscription }
    end
  end
end
