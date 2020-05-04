class Question < ApplicationRecord
  belongs_to :problem
  has_many :question_choices, dependent: :destroy
  accepts_nested_attributes_for :question_choices, allow_destroy: true
  validates :content, presence: true, length: { maximum: 20 }
  validate :answer_present
  validates :description, presence: true, length: { maximum: 255 }

  def answer_present
    if problem.question_style == 2 && answer.blank?
      errors.add(:answer, "を入力してください")
    end
  end

end
