FactoryBot.define do
  factory :question do
    content {"aaaa"}
    answer {"aaaa"}
    description {"aaaaaああああ"}
    association :problem
  end

  factory :check_question, class: Question do
    content {"aaaa"}
    answer {1}
    description {"aaaaa"}
    association :problem
  end
end
