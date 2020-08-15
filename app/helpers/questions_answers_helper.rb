module QuestionsAnswersHelper

  def get_correct_content(question)
    correct = true
    question.question_choices.each_with_index do |choice, id|
      if choice.choice == true
        correct = choice.content
        break
      end
    end
    correct
  end

end
