class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "data-question-id=#{data['question_id']}"
  end
end
