require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  it 'change value to 1' do
    votable.upvote(user)
    expect(Vote.last.value).to eq 1
    expect(votable.rating).to eq 1
  end

  it 'change value to -1' do
    votable.downvote(user)
    expect(Vote.last.value).to eq(-1)
    expect(votable.rating).to eq(-1)
  end

  it 'not change value if already voted' do
    votable.downvote(user)
    votable.downvote(user)
    expect(votable.rating).to eq(-1)
  end

  it 'drop value to 0' do
    votable.upvote(user)
    votable.vote_canceling(user)
    expect(votable.rating).to eq 0
  end

  it 'calculate rating between votes' do
    votable.downvote(user)
    votable.upvote(user2)
    expect(votable.rating).to eq(0)
  end
end
