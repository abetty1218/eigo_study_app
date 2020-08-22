class QuestionChoice < ApplicationRecord
  belongs_to :question
  validates :content, presence: true, length: { maximum: 20 }
  default_scope -> { order(id: :asc) }
end
