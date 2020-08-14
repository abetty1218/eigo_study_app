class Question < ApplicationRecord
   has_many :question_choices, dependent: :destroy
   has_many :question_answers, dependent: :destroy
   belongs_to :problem
   accepts_nested_attributes_for :question_choices, allow_destroy: true
   validates :content, presence: true, length: { maximum: 20 }
   validate :answer_present
   validates :japaneseexample, presence: true, length: { maximum: 255 }
   validates :englishexample, presence: true, length: { maximum: 255 }


   def answer_present
     if problem.question_style == 2 && answer.blank?
       errors.add(:answer, "を入力してください")
     end
   end

   def self.next(id)
     Question.where("id > ?",id).order("id ASC").first
   end

   def self.previous(id)
     Question.here("id < ?",id).order("id DESC").first
   end

end
