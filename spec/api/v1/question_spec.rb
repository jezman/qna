require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/id' do
    let(:api_path) { '/api/v1/questions/id' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      include ControllerHelpers

      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: user) }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      before { 3.times { attach_file_to(question) } }

      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all question public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      context 'comments' do
        let(:comment) { comments.last }
        let(:comments_response) { question_response['comments'] }
        let(:comment_response) { comments_response.first }

        it 'rerurn list of comments' do
          expect(comments_response.size).to eq comments.size
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      context 'links' do
        let(:link) { links.last }
        let(:links_response) { question_response['links'] }
        let(:link_response) { links_response.first }

        it 'rerurn list of links' do
          expect(links_response.size).to eq links.size
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      context 'files' do
        let(:file) { question.files.first.blob }
        let(:files_response) { question_response['files'] }
        let(:file_response) { files_response.first }

        it 'rerurn list of files' do
          expect(files_response.size).to eq question.files.size
        end

        it 'returns all public fields' do
          %w[id filename].each do |attr|
            expect(file_response[attr]).to eq file.send(attr).as_json
          end
        end

        it 'contains link to file'
      end
    end
  end
end
