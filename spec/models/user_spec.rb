require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :badges }
  it { should have_many :likes }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:any_user) { create(:user) }

    it 'current user is author' do
      question = create(:question, user: user)

      expect(user).to be_author(question)
    end

    it 'current user not an author' do
      question = create(:question, user: any_user)

      expect(user).to_not be_author(question)
    end
  end

  describe '#award_badge!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:badge) { create(:badge, question: question) }

    it 'user awarding the badge' do
      user.award_badge!(badge)

      expect(badge).to eq user.badges.last
    end
  end

  describe '#liked?' do
    let(:user) { create(:user) }
    let(:liker) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { question.vote_up(liker) }

    it 'user already liked the resource' do
      expect(liker).to be_liked(question)
    end

    it 'user has not liked the resource' do
      expect(user).to_not be_liked(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#create_authorization' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    it 'add authorization to user' do
      expect(user.create_authorization(auth)).to eq user.authorizations.last
    end
  end

  describe '#email_temporary?' do
    let(:user) { create(:user) }
    let(:user_with_temp_email) { create(:user, email: User::TEMPORARY_EMAIL) }

    it 'user have a real email' do
      expect(user.email_temporary?).to be_falsey
    end

    it 'user email is temporary' do
      expect(user_with_temp_email.email_temporary?).to be_truthy
    end
  end
end
