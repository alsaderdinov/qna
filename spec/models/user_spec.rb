require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end

describe 'user is author?' do
  let(:user) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'the user is author' do
    expect(user).to be_author_of(question)
  end

  it 'the user is not the author' do
    expect(not_author).to_not be_author_of(question)
  end
end

describe 'user subscriber of?' do
  let(:user) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:subscription) { create(:subscription, question: question, user: user) }

  it 'the user subscriber of question' do
    expect(user).to be_subscriber_of(question)
  end

  it 'the user does not subscriber of question' do
    expect(not_author).to_not be_subscriber_of(question)
  end
end
