class Answer < ApplicationRecord
  default_scope { order(best: :desc).order(created_at: :asc) }

  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  has_many_attached :files

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
