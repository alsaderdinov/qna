class NewAnswerNotificationService
  def send_new_answer_notification(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerNotificationMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
