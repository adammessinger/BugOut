FactoryGirl.define do
  factory(:user, class: 'User', aliases: [:reporter, :assignee, :author]) do
    sequence(:email) do |n|
      "#{Faker::Internet.user_name}#{n}@example." + %w(com net org edu).sample
    end
    name { [true, false].sample ? Faker::Name.name_with_middle : Faker::Name.name }
    password { Faker::Internet.password }
  end
end
