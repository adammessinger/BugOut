require 'rails_helper'

describe User, type: :model do
  it { should have_many(:reports) }
  it { should have_many(:assignments) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(2).is_at_most(255) }

  describe 'validates case-insensitive uniqueness of email address' do
    # NOTE: Must build a User instance that satisfies all schema constraints due to the way validate_uniqueness_of works.
    # Details: https://github.com/thoughtbot/shoulda-matchers/blob/master/lib/shoulda/matchers/active_record/validate_uniqueness_of_matcher.rb#L26
    subject { build(:user) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
