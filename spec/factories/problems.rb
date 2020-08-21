FactoryBot.define do
  factory :problem do
    question_style {2}
    released_on {nil}
    released {false}
    sequence(:number) { |n| n+2 }
  end

  factory :problem1, class: Problem do
    question_style {2}
    released_on {"2019-01-01"}
    released {true}
    number {1}
  end

  factory :problem2, class: Problem do
    question_style {1}
    released_on {"2019-01-01"}
    released {false}
    number {2}
  end
end
