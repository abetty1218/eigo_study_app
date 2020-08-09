# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "管理者",
             email: "admin@email.com",
             password: "password",
             password_confirmation: "password",
             check: "no_mail",
             admin: true)

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               check: "no_mail"
             )
end

10.times do |n|
  title  = "test"
  description = "てすと"
  Notice.create!(title: title,
               description: description)
end


Problem.create!(question_style:2,number:1)
Problem.create!(question_style:1,number:2)
Problem.create!(question_style:2,number:3)
Problem.create!(question_style:1,number:4)

Question.create!(content: "興味深い、面白い",answer: "interesting", japaneseexample: "この本は面白い", englishexample: "This is an interesting book", problem_id: 1)
Question.create!(content: "覚える",answer: "remember", japaneseexample: "私は、英単語を覚えます。", englishexample: "I remember English words", problem_id: 1)
Question.create!(content: "友達",answer: "friend", japaneseexample: "あなたは、私の友達です", englishexample: "You are my friend", problem_id: 1)

Question.create!(content: "毎日",answer: "2", japaneseexample: "私は、毎日テニスをします。", englishexample: "I play tennis every day", problem_id: 2)
Question.create!(content: "起きる",answer: "1", japaneseexample: "朝はたいてい何時に起きますか？", englishexample: "What time do you usually get up in the morning?", problem_id: 2)
Question.create!(content: "りんご",answer: "3", japaneseexample: "私は、りんごがすきです。", englishexample: "I like apples", problem_id: 2)

Question.create!(content: "車",answer: "car", japaneseexample: "それは、私の車です", englishexample: "It is my car", problem_id: 3)
Question.create!(content: "朝食",answer: "breakfast", japaneseexample: "私は毎日朝食を食べます", englishexample: "I eat breakfast every day", problem_id: 3)
Question.create!(content: "のむ",answer: "drink", japaneseexample: "私は、コーヒーを飲みます。", englishexample: "I drink coffee", problem_id: 3)

Question.create!(content: "兄弟",answer: "4", japaneseexample: "私には、兄弟がいない", englishexample: "I don't have a brother", problem_id: 4)
Question.create!(content: "駅",answer: "1", japaneseexample: "私は、その駅に行きたい。", englishexample: "I want to go to that station.", problem_id: 4)
Question.create!(content: "集める",answer: "3", japaneseexample: "私の兄は、趣味に切手を集めている.", englishexample: "My brother collects stamps for a hobby", problem_id: 4)

QuestionChoice.create!(choice: false, content:"all day", question_id: 4)
QuestionChoice.create!(choice: true, content:"every day", question_id: 4)
QuestionChoice.create!(choice: false, content:"each day", question_id: 4)
QuestionChoice.create!(choice: false, content:"another day", question_id: 4)

QuestionChoice.create!(choice: true, content:"get up", question_id: 5)
QuestionChoice.create!(choice: false, content:"get on", question_id: 5)
QuestionChoice.create!(choice: false, content:"get at", question_id: 5)
QuestionChoice.create!(choice: false, content:"get in", question_id: 5)

QuestionChoice.create!(choice: false, content:"cherry", question_id: 6)
QuestionChoice.create!(choice: false, content:"peach", question_id: 6)
QuestionChoice.create!(choice: true, content:"apple", question_id: 6)

QuestionChoice.create!(choice: false, content:"sister", question_id: 10)
QuestionChoice.create!(choice: false, content:"father", question_id: 10)
QuestionChoice.create!(choice: false, content:"mother", question_id: 10)
QuestionChoice.create!(choice: true, content:"brother", question_id: 10)

QuestionChoice.create!(choice: true, content:"station", question_id: 11)
QuestionChoice.create!(choice: false, content:"village", question_id: 11)
QuestionChoice.create!(choice: false, content:"town", question_id: 11)
QuestionChoice.create!(choice: false, content:"church", question_id: 11)

QuestionChoice.create!(choice: false, content:"send", question_id: 12)
QuestionChoice.create!(choice: false, content:"wait", question_id: 12)
QuestionChoice.create!(choice: true, content:"collect", question_id: 12)
