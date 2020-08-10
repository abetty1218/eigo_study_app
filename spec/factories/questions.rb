FactoryBot.define do
  factory :question do
    content {"aaaa"}
    answer {"aaaa"}
    japaneseexample {"これは本です。"}
    englishexample {"This is a book"}
    association :problem
  end

  factory :check_question, class: Question do
    content {"aaaa"}
    answer {1}
    japaneseexample {"これは本です。"}
    englishexample {"This is a book"}
    association :problem
  end
end
