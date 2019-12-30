# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# To run your seeds, do:
# rails db:seed


NUM_QUESTIONS = 200
NUM_USERS = 10
PASSWORD = "supersecret"

Like.delete_all
Tagging.delete_all
Tag.delete_all
Answer.delete_all
Question.delete_all
User.delete_all

super_user = User.create(
  first_name: "Jon",
  last_name: "Snow",
  address: Faker::Address.full_address,
  email: "js@winterfell.gov",
  password: PASSWORD
)

NUM_USERS.times do
  first_name =  Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end
users = User.all

20.times do
  Tag.create(
    name: Faker::Book.genre
  )
end
tags = Tag.all

NUM_QUESTIONS.times do
  created_at = Faker::Date.backward(365 * 5)
  q = Question.create(
    # Faker is a ruby module. We access classes
    # or other modules inside of it with ::.
    # Here, Hacker is a class inside of the
    # Faker module
    title: Faker::Hacker.say_something_smart,
    body: Faker::ChuckNorris.fact,
    created_at: created_at,
    updated_at: created_at,
    aasm_state: Question.aasm.states.map(&:name).sample,
    user: users.sample
  )
  if q.valid?
    q.answers = rand(0..15).times.map do
      Answer.new(
        body: Faker::GreekPhilosophers.quote,
        user: users.sample
      )
    end
    q.likers = users.shuffle.slice(0, rand(users.count))
    q.tags = tags.shuffle.slice(0, rand(tags.count / 2))
  end
end

questions = Question.all
answers = Answer.all

puts Cowsay.say("Generated #{questions.count} questions", :frogs)
puts Cowsay.say("Generated #{answers.count} answers", :tux)
puts Cowsay.say("Generated #{users.count} users", :stegosaurus)
puts Cowsay.say("Generated #{tags.count} tags", :kitty)


puts "Login with #{super_user.email} and password: #{PASSWORD}"
