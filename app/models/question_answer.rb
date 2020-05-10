class QuestionAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :problem
  belongs_to :user
  validates :answer, presence: true, length: { maximum: 20 }
end
