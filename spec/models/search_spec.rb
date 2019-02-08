require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    Search::RESOURCES.each do |model|
      it "search in #{model}" do
        expect(model.constantize).to receive(:search).with('sphinx')
        Search.find('sphinx', model)
      end
    end

    it 'search in all objects' do
      expect(ThinkingSphinx).to receive(:search).with('sphinx')
      Search.find('sphinx', nil)
    end
  end
end
