require 'rails_helper'

shared_examples_for 'commented' do
  let!(:commented) { described_class.controller_name.classify.constantize }
  let!(:commentable) { create(commented.to_s.underscore.to_sym, user: user) }
  let!(:user) { create(:user) }

  describe 'POST #create_comment' do
    context 'As authenticated user' do
      before { login(user) }

      it 'create comment' do
        expect do
          post :create_comment, params: { id: commentable, comment: attributes_for(:question), format: :js }
        end.to change {
                 commentable.comments.count
               }.by(1)
      end
    end

    context 'As unauthenticated user' do
      it 'not create comment' do
        expect do
          post :create_comment, params: { id: commentable, comment: attributes_for(:question), format: :js }
        end.to_not change {
                     commentable.comments.count
                   }
      end
    end
  end
end
