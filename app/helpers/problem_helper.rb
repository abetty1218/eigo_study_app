module ProblemHelper

  def get_correct_rate(problem,correct_count)
    question_count = problem.questions.count
    correct_rate = 100 * correct_count / question_count
  end

  def get_try(problem_answer,problem,current_answer,first_answer)
    if first_answer.count == problem.questions.count
      answer = problem_answer.where(question_id: problem.questions.first.id)
      if current_answer.count == problem.questions.count
        answer.last.try + 1
      else
        answer.last.try
      end
    else
      0
    end
  end

  def get_admin_name(problem)
    if problem.question_style == 1
      "質問一覧（選択式）"
    else
      "質問一覧（記述式）"
    end
  end

  def get_name(problem,first_answer)
    if problem.question_style == 1
      if first_answer.count == problem.questions.count
        "再チャレンジ（選択式）!!"
      else
        "質問（選択式）"
      end
    else
      if first_answer.count == problem.questions.count
        "再チャレンジ（記述式）!!"
      else
        "質問（記述式）"
      end
    end
  end

  def get_correct_count_try(last_try,current_answer,problem)
    if last_try == 0
      last_try
    elsif last_try.to_i  >= 1
      if current_answer.count ==  problem.questions.count
        last_try
      else
        last_try - 1
      end
    end
  end
end
