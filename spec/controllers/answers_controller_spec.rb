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
          post :create,
               params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(question.answers, :count)
      end

      it 're-renders show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end

    it 'renders show template' do
      patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      expect(response).to render_template :update
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders show template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'not author tries update answer' do
      let(:not_author) { create(:user) }
      let!(:answer2) { create(:answer, question: question, user: not_author) }
      it 'does not change answer attributes' do
        patch :update, params: { id: answer2, answer: { body: 'new body' } }, format: :js
        answer2.reload

        expect(answer2.body).to_not eq 'New body'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'Author delete onw answer' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to questions/show' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author delete answer' do
      let(:not_author) { create(:user) }
      let!(:not_author_answer) { create(:answer, question: question, user: not_author) }
      it 'answer not delete' do
        expect { delete :destroy, params: { id: not_author_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render question/show' do
        delete :destroy, params: { id: not_author_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
