require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question
          }, format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'assigns a new answer to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).question).to eq question
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer, :invalid_answer),
            question_id: question,
            format: :js
          }
        end.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: {
          answer: attributes_for(:answer, :invalid_answer),
          question_id: question,
          format: :js
        }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let!(:author_answer) { create(:answer, question: question, user: author) }

    context 'with valid attributes' do
      before { login(author) }

      it 'changes answer attributes' do
        patch :update, params: { id: author_answer, answer: { body: 'new body' } }, format: :js
        author_answer.reload
        expect(author_answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: author_answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        end.to_not change(author_answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: author_answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:author_answer) { create(:answer, question: question, user: author) }

    context 'user an author' do
      before { login(author) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: author_answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: author_answer }
        expect(response).to redirect_to question
      end
    end

    context 'user is not an author' do
      before { login(user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: author_answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: author_answer }
        expect(response).to redirect_to author_answer.question
      end
    end
  end
end
