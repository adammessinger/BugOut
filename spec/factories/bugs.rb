FactoryGirl.define do
  factory(:bug, class: 'Bug') do
    title { "#{Faker::Commerce.product_name} can’t #{Faker::Company.bs}" }
    reporter
    description { "#{Faker::Lorem.paragraph}\n#{Faker::Hacker.say_something_smart}" }
  end
end
