require 'rails_helper'

shared_examples_for 'voted' do
  let!(:voted) { described_class.controller_name.classify.constantize }
  let!(:votable) { create(voted.to_s.underscore.to_sym, user: author) }
  let!(:voter) { create(:user) }
  let!(:author) { create(:user) }

  describe 'POST #upvote' do
    context 'User is not author of resource' do
      before { login(voter) }

      it 'change votable rating' do
        expect { post :upvote, params: { id: votable, format: :json } }.to change { votable.rating }.by(1)
      end

      it 'returns data json' do
        post :upvote, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq %w[resource rating id]
      end
    end

    context 'User is author of resource' do
      before { login(author) }

      it 'not change votable rating as positive' do
        expect { post :upvote, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns errors json' do
        post :upvote, params: { id: votable, format: :json }
        expect(response.status).to eq 422
      end
    end
  end

  describe 'POST #downvote' do
    context 'User is not author of resource' do
      before { login(voter) }

      it 'change votable rating as negative' do
        expect { post :downvote, params: { id: votable, format: :json } }.to change { votable.rating }.by(-1)
      end

      it 'returns data json' do
        post :downvote, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq %w[resource rating id]
      end
    end

    context 'User is an author of resource' do
      before { login(author) }

      it 'not change votable rating as positive' do
        expect { post :downvote, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns errors json' do
        post :downvote, params: { id: votable, format: :json }
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE #vote_canceling' do
    context 'User is not author of resource' do
      before { login(voter) }

      it 'delete votes' do
        post :upvote, params: { id: votable, format: :json }
        expect { delete :vote_canceling, params: { id: votable, format: :json } }.to change {
                                                                                       votable.rating
                                                                                     }.from(1).to(0)
      end

      it 'returns data json' do
        post :vote_canceling, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq %w[resource rating id]
      end
    end

    context 'User is an author of resource' do
      before { login(author) }

      it 'not delete votes' do
        post :upvote, params: { id: votable, format: :json }
        expect { delete :vote_canceling, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns errors json' do
        post :vote_canceling, params: { id: votable, format: :json }
        expect(response.status).to eq 422
      end
    end
  end
end
