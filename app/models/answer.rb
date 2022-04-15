class Answer < ApplicationRecord
  default_scope { order(best: :desc).order(created_at: :asc) }
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  has_many_attached :files

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
