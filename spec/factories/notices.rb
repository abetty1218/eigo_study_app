FactoryBot.define do
  factory :notice do
    title {"aaaa"}
    description {"bbbbbbb"}
  end

  factory :notice1, class: Notice do
    title {"aaaa"}
    description {"bbbbbbb"}
  end
end
