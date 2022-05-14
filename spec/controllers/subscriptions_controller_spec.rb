require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    it 'saves a new subscription in the database' do
      expect { post :create, params: { question_id: question, format: :js } }.to change(question.subscriptions, :count).by(1)
    end

    it 'renders create view' do
      post :create, params: { question_id: question, format: :js }
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }
    before { login(user) }

    it 'deletes the subscription from the database' do
      expect { delete :destroy, params: { id: subscription, format: :js } }.to change(question.subscriptions, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: subscription, format: :js }
      expect(response).to render_template :destroy
    end
  end
end
