require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('NewAnswerNotificationService') }
  let(:answer) { create(:answer) }

  before do
    allow(NewAnswerNotificationService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerNotificationService#notify' do
    expect(service).to receive(:notify)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
