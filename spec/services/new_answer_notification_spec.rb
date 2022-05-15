require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:sub) { create(:user) }
  let(:question) { create(:question, user: sub) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to the subscriber when new answer created' do
    expect(NewAnswerNotificationMailer).to receive(:notify).with(sub, answer).and_call_original
    subject.send_new_answer_notification(answer)
  end
end
