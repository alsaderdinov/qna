# Preview all emails at http://localhost:3000/rails/mailers/new_answer_notification
class NewAnswerNotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notification/notify
  def notify
    NewAnswerNotificationMailer.notify
  end

end
