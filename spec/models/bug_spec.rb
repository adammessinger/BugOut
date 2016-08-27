require 'rails_helper'

describe Bug, type: :model do
  let(:valid_attributes) do
    {
      title: 'My Descriptive Title',
      description: 'My sufficiently detailed description.',
      closed: false,
      reporter_id: 1
    }
  end
  let(:user_bob_atts) { { email: 'bob@example.com', password: '234&098qtpg9a732' } }
  let(:user_jane_atts) { { email: 'jane@example.com', password: '=45y8hj@pob#n8e4' } }

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
        bug = Bug.new(valid_attributes)
        expect(bug).to(be_valid)
      end
    end

    context 'with required fields not filled' do
      it 'is invalid without a title' do
        valid_attributes[:title] = nil
        bug = Bug.new(valid_attributes)
        bug.valid?
        expect(bug.errors[:title]).to(include "can't be blank")
      end

      it 'is invalid without a reporter_id' do
        valid_attributes[:reporter_id] = nil
        bug = Bug.new(valid_attributes)
        bug.valid?
        expect(bug.errors[:reporter_id]).to(include "can't be blank")
      end

      it 'is invalid without a description' do
        valid_attributes[:description] = nil
        bug = Bug.new(valid_attributes)
        bug.valid?
        expect(bug.errors[:description]).to(include "can't be blank")
      end
    end

    context 'with valid or invalid User associations' do
      before(:example) do
        valid_attributes[:reporter_id] = nil
        @bug = Bug.new(valid_attributes)
      end

      it 'is valid if reporter record is valid' do
        @bug.create_reporter!(user_jane_atts)
        @bug.valid?
        expect(@bug).to(be_valid)
      end

      it 'is valid if assignee record is valid' do
        @bug.create_reporter!(user_bob_atts)
        @bug.create_assignee!(user_jane_atts)
        @bug.valid?
        expect(@bug).to(be_valid)
      end

      it 'is invalid if reporter record is invalid' do
        @bug.build_reporter(id: 9999, email: nil)
        @bug.save
        expect(@bug.errors[:reporter]).to(include 'is invalid')
      end

      it 'is invalid if assignee record is invalid' do
        @bug.build_assignee(id: 9999, email: nil)
        @bug.save
        expect(@bug.errors[:assignee]).to(include 'is invalid')
      end
    end
  end

  describe '#owned_by?' do
    before(:example) do
      @bug = Bug.new(valid_attributes)
      @bob = User.new(user_bob_atts)
      @jane = User.new(user_jane_atts)
      @bug.reporter = @bob
      @bug.assignee = @jane
    end

    it 'returns true if passed user arg matches bug reporter' do
      expect(@bug.owned_by?(@bob)).to(be true)
    end

    it 'returns true if passed user arg matches bug assignee' do
      expect(@bug.owned_by?(@jane)).to(be true)
    end

    it 'returns true if passed user arg matches bug reporter and assignee' do
      @bug.reporter = @jane

      expect(@bug.owned_by?(@jane)).to(be true)
    end

    it 'returns false if passed user arg matches NIETHER reporter NOR assignee' do
      alice = User.new(email: 'alice@example.com', password: 'apwrhp9^%/*&z#x!vjdf')

      expect(@bug.owned_by?(alice)).to(be false)
    end

    it 'returns nil if passed a non-user argument' do
      nonsense = Object.new

      expect(@bug.owned_by?(nonsense)).to(be nil)
    end

    it 'returns nil if passed no argument (user param defaults to nil)' do
      expect(@bug.owned_by?).to(be nil)
    end
  end
end
