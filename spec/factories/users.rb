FactoryBot.define do
  factory :user do
    name {"Aaron"}
    sequence(:email) { |n| "tester#{n}@example.com" }
    password {"dottle-nouveau-pavilion-tights-furze"}
    check {"メールを受け取る"}
  end

  factory :admin , class: User do
    name {"Aaron"}
    email {"admin@example.com" }
    password {"dottle-nouveau-pavilion-tights-furze"}
    check {"メールを受け取る"}
    admin {true}
  end
end
