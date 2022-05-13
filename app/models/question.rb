class Question < ApplicationRecord
  include Votable
  include Linkable
  include Fileable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_to_question

  private

  def subscribe_to_question
    subscriptions.create(user: user)
  end
end
