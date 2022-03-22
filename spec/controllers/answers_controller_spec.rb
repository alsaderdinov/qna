require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it { should render_template('new') }
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create,
               params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect {
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end

    describe 'DELETE #destroy' do
      before { login(user) }

      context 'Author delete onw answer' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'delete the answer' do
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end

        it 'redirects to questions/show' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'Not author delete answer' do
        let(:not_author) { create(:user) }
        let!(:not_author_answer) { create(:answer, question: question, user: not_author) }
        it 'answer not delete' do
          expect { delete :destroy, params: { id: not_author_answer } }.to_not change(Answer, :count)
        end

        it 'render question/show' do
          delete :destroy, params: { id: not_author_answer }
          expect(response).to render_template 'questions/show'
        end
      end
    end
  end
end
