require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

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

  describe 'PATCH #best' do
    let(:user) { create(:user) }
    let(:not_author) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'User is author of question' do
      before { login(user) }

      it 'set best answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to be
      end

      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'User is not author of question' do
      before { login(not_author) }

      it 'tries to select best answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).not_to be
      end

      it 'redirects to root path' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to have_http_status 403
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

      it 'redirects to root path' do
        delete :destroy, params: { id: not_author_answer }, format: :js
        expect(response).to have_http_status 403
      end
    end
  end
end
