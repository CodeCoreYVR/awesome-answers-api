FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # Use the `sequence` method in a factory to get a
    # counter of how many times the factory was used as
    # an argument to its passed in block. This is especially
    # useful when dealing with a column that requires
    # uniqueness validation
    sequence(:email) {
      |n| Faker::Internet.email.sub("@", "-#{n}@")
    }
    password { "supersecret" }
  end
end
