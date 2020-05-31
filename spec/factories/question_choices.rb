FactoryBot.define do
  factory :question_choice do
    content {"qqqq"}
    choice {true}
    association :question
  end

  factory :question_choice2 , class: QuestionChoice do
    content {"qqqqee"}
    choice {false}
    association :question
  end

  factory :question_choice3 , class: QuestionChoice do
    content {"qqqqee"}
    choice {false}
    association :question
  end

  factory :question_choice4 , class: QuestionChoice do
    content {"qqqqee"}
    choice {false}
    association :question
  end
end
