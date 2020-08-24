module QuestionsHelper

  def current_question(problem,current_question)
    number = 0
    problem.questions.order(id: :asc).each do |question|
    number += 1
      if question.id == current_question.id
        break
      end
    end
    number
  end

end
