require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    Search::RESOURCES.each do |resource|
      it "search in #{resource}" do
        expect(Search).to receive(:find).with('sphinx', resource)
        get :index, params: { query: 'sphinx', resource: resource }
      end
    end

    it 'search everywhere' do
      expect(Search).to receive(:find).with('sphinx', nil)
      get :index, params: { query: 'sphinx' }
    end

    it 'renders index view' do
      expect(Search).to receive(:find).with('sphinx', nil)
      get :index, params: { query: 'sphinx' }
      expect(response).to render_template :index
    end
  end
end
