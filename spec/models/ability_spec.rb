require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:question_with_attachment) { create(:question, :with_attachment, user: user) }
    let(:answer) { create :answer, question: question, user: user }
    let(:answer_with_attachment) { create(:answer, :with_attachment, user: user) }

    let(:other) { create :user }
    let(:other_question) { create(:question, user: other) }
    let(:other_question_with_attachment) { create(:question, :with_attachment, user: other) }
    let(:other_answer) { create(:answer, question: other_question, user: other) }
    let(:other_answer_with_attachment) { create(:answer, :with_attachment, user: other) }

    it { should_not be_able_to :manage, :all }

    context 'read' do
      it { should be_able_to :read, :all }
    end

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create_comment, Question }
      it { should be_able_to :create_comment, Answer }
    end

    context 'update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }
    end

    context 'votes for question' do
      it { should be_able_to :upvote, other_question }
      it { should be_able_to :downvote, other_question }
      it { should be_able_to :vote_canceling, other_question }

      it { should_not be_able_to :upvote, question }
      it { should_not be_able_to :downvote, question }
      it { should_not be_able_to :vote_canceling, question }
    end

    context 'votes for answer' do
      it { should be_able_to :upvote, other_answer }
      it { should be_able_to :downvote, other_answer }
      it { should be_able_to :vote_canceling, other_answer }

      it { should_not be_able_to :upvote, answer }
      it { should_not be_able_to :downvote, answer }
      it { should_not be_able_to :vote_canceling, answer }
    end

    context 'choose best answer' do
      it { should be_able_to :best, answer }
      it { should_not be_able_to :best, other_answer }
    end

    context 'destroy' do
      it { should be_able_to :destroy, create(:question, user_id: user.id) }
      it { should_not be_able_to :destroy, create(:question, user_id: other.id) }

      it { should be_able_to :destroy, create(:answer, user_id: user.id) }
      it { should_not be_able_to :destroy, create(:answer, user_id: other.id) }
    end

    context 'destroy question attachment' do
      it { should be_able_to :destroy, question_with_attachment.files.last }
      it { should_not be_able_to :destroy, other_question_with_attachment.files.last }
    end

    context 'answer attachment' do
      it { should be_able_to :destroy, answer_with_attachment.files.last }
      it { should_not be_able_to :destroy, other_answer_with_attachment.files.last }
    end

    context 'question link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end

    context 'answer link' do
      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }
    end
  end
end
