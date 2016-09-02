FactoryGirl.define do
  factory(:bug, class: 'Bug') do
    title { "#{Faker::Commerce.product_name} can’t #{Faker::Company.bs}" }
    reporter
    description { "#{Faker::Lorem.paragraph}\n#{Faker::Hacker.say_something_smart}" }

    factory(:bug_with_comments) do
      transient do
        comments_count(3)
      end

      after(:create) do |bug, evaluator|
        create_list(:comment, evaluator.comments_count, bug: bug)
      end
    end
  end
end
