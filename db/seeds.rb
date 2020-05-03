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
             check: "no_male",
             admin: true)

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               check: "no_male"
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
Problem.create!(question_style:1,number:3)
Problem.create!(question_style:1,number:4)
