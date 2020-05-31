class Problem < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true
  validates :question_style, presence: true
  validates :number, presence: true, uniqueness: true
end
