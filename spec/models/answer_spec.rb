require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'fileable'
  it_behaves_like 'linkable'

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }


  describe 'set best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }

    it 'select the best answer' do
      answer.set_best!
      expect(answer).to be_best
    end

    it 'only one answer can be best' do
      answers.each(&:set_best!)
      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'best answer must be first' do
      answers.last.set_best!
      expect(question.answers.first).to be_best
    end
  end
end
