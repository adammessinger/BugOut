FactoryGirl.define do
  factory :comment do
    bug
    author
    body { Faker::Hipster.paragraph(2) }
  end
end
