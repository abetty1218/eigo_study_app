FactoryBot.define do
  factory :user do
    name {"Aaron"}
    sequence(:email) { |n| "tester#{n}@example.com" }
    password {"dottle-nouveau-pavilion-tights-furze"}
    check {"no_mail"}
  end

  factory :user1 , class: User do
    name {"Aaron"}
    email {"test@example.com"}
    password {"dottle-nouveau-pavilion-tights-furze"}
    check {"mail"}
  end

  factory :admin , class: User do
    name {"Aaron"}
    email {"admin@example.com" }
    password {"dottle-nouveau-pavilion-tights-furze"}
    check {"no_mail"}
    admin {true}
  end
end
