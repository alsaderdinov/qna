# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_attachment, user: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author tries delete attachments files of question' do
      it 'delete attachment file' do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author tries delete attachments files of question' do
      let(:not_author) { create(:user) }
      let!(:not_author_question) { create(:question, :with_attachment, user: not_author) }
      it 'attachment file not delete' do
        expect do
          delete :destroy, params: { id: not_author_question.files.first }, format: :js
        end.to_not change(not_author_question.files, :count)
      end

      it 'renders questions/show view' do
        delete :destroy, params: { id: not_author_question.files.first }, format: :js
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
