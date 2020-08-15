class QuestionAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :problem
  belongs_to :user
  validates :answer, presence: true, length: { maximum: 20 }

  def self.get_problem_answer(problem,try)
    QuestionAnswer.where("problem_id = ?",problem).where("try = ?",try)
  end
end
