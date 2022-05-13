class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotificationService.new.notify(answer)
  end
end
