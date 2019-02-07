require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  it { should have_one :badge }
  it { should have_db_index :user_id }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it_behaves_like 'likable'
  it_behaves_like 'commentable'

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#subscribe' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'after create question the author automatically subscribes' do
      expect(question.subscribers).to include user
    end

    it 'subscribe other user' do
      question.subscribe(other_user)

      expect(question.subscribers).to include other_user
    end
  end

  describe '#unsubscribe' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { question.subscribe(other_user) }

    it 'unsubscribe from question' do
      question.unsubscribe(other_user)

      expect(question.subscribers).to_not include other_user
    end
  end
end
