require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user1) { create(:user) }
  let!(:user1_question) { create(:question, user: user1) }
  let!(:user1_link) { create(:link, linkable: user1_question) }

  let(:user2) { create(:user) }
  let!(:user2_question) { create(:question, user: user2) }
  let!(:user2_link) { create(:link, linkable: user2_question) }

  describe 'DELETE #destroy' do
    before { login(user1) }

    context 'Author tries to delete question links' do
      it 'delete link' do
        expect { delete :destroy, params: { id: user1_link }, format: :js }.to change(user1_question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: user1_link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author tries to delete question links' do
      it 'not delete question link' do
        expect { delete :destroy, params: { id: user2_link }, format: :js }.to_not change(user2_question.links, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: user2_link }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
