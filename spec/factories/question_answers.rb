FactoryBot.define do
  factory :question_answer do
    answer {"aaaa"}
    try {0}
    correct{true}
    association :problem
    association :question
    association :user
  end

  factory :non_answer, class: QuestionAnswer do
    answer {"aaaaaaa"}
    try {0}
    correct{true}
    association :problem
    association :question
    association :user
  end
end
