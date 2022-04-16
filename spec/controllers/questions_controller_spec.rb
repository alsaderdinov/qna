require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'popluates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it { should render_template('index') }
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it { should render_template('show') }
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it { should render_template('new') }
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    describe 'DELETE #destroy' do
      before { login(user) }

      context 'Author delete own question' do
        let!(:question) { create(:question, user: user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'Not author delete question' do
        let(:not_author) { create(:user) }
        let!(:not_author_question) { create(:question, user: not_author) }

        it 'question not delete' do
          expect { delete :destroy, params: { id: not_author_question } }.to_not change(Question, :count)
        end

        it 'render show' do
          delete :destroy, params: { id: not_author_question }
          expect(response).to render_template :show
        end
      end
    end

    describe 'PATCH #update' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }
      context 'with valid attributes' do
        before {
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        }
        it 'changes question attributes' do
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders show template' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question attributes' do
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 'renders show template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'not not author tries update question' do
      let(:not_author) { create(:user) }
      let!(:question2) { create(:question, user: not_author) }

      it 'does not change question attributes' do
        patch :update, params: { id: question2, question: { body: 'not_author_body' } }, format: :js
        question2.reload

        expect(question2.body).to_not eq 'not_author_body'
      end
    end
  end
end
