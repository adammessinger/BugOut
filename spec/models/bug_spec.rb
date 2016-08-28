require 'rails_helper'

describe Bug, type: :model do
  it { should belong_to(:reporter) }
  it { should belong_to(:assignee) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should validate_uniqueness_of(:title).case_insensitive }
  it { should validate_presence_of(:reporter_id) }
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_least(24).is_at_most(65_000) }
  it { should validate_uniqueness_of(:description).case_insensitive }

  describe 'validation checking' do
    context 'with required fields filled' do
      it 'is valid with a title, description, and reporter_id' do
        expect(build(:bug)).to(be_valid)
      end
    end

    context 'with required fields not filled' do
      it 'is invalid without a title' do
        bug = build(:bug, title: nil)

        bug.valid?
        expect(bug.errors[:title]).to(include "can't be blank")
      end

      it 'is invalid without a reporter' do
        bug = build(:bug, reporter: nil)

        bug.valid?
        expect(bug.errors[:reporter_id]).to(include "can't be blank")
      end

      it 'is invalid without a description' do
        bug = build(:bug, description: nil)

        bug.valid?
        expect(bug.errors[:description]).to(include "can't be blank")
      end
    end

    context 'with valid User associations' do
      before(:example) do
        @reporter = create(:user)
        @assignee = create(:user)
      end

      it 'is valid if reporter record is valid' do
        bug = build(:bug, reporter: @reporter)

        bug.valid?
        expect(bug).to(be_valid)
      end

      it 'is valid if assignee record is valid' do
        bug = build(:bug, assignee: @assignee)

        bug.valid?
        expect(bug).to(be_valid)
      end
    end

    context 'with invalid User associations' do
      it 'is invalid if reporter record is invalid' do
        bug = build(:bug, reporter_id: 99_999)

        bug.valid?
        expect(bug.errors[:reporter]).to(include "can't be blank")
      end

      it 'is invalid if assignee record is invalid' do
        bug = build(:bug, assignee_id: 99_999)

        bug.valid?
        expect(bug.errors[:assignee]).to(include "can't be blank")
      end
    end
  end

  describe '#owned_by?' do
    before(:example) do
      @reporter = create(:user)
      @assignee = create(:user)
      @generic_bug = build(:bug)
    end

    it 'returns true if passed user arg matches bug reporter' do
      bug = build(:bug, reporter: @reporter)

      expect(bug.owned_by?(@reporter)).to(be true)
    end

    it 'returns true if passed user arg matches bug assignee' do
      bug = build(:bug, assignee: @assignee)

      expect(bug.owned_by?(@assignee)).to(be true)
    end

    it 'returns true if passed user arg matches bug reporter and assignee' do
      both = create(:user)
      bug = build(:bug, reporter: both, assignee: both)

      expect(bug.owned_by?(both)).to(be true)
    end

    it 'returns false if passed user arg matches NIETHER reporter NOR assignee' do
      nope = build(:user)

      expect(@generic_bug.owned_by?(nope)).to(be false)
    end

    it 'returns nil if passed a non-user argument' do
      nonsense = Object.new

      expect(@generic_bug.owned_by?(nonsense)).to(be nil)
    end

    it 'returns nil if passed no argument (user param defaults to nil)' do
      expect(@generic_bug.owned_by?).to(be nil)
    end
  end
end
