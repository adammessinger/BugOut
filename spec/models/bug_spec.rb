require 'rails_helper'

describe Bug, type: :model do
  let(:valid_attributes) do
    { title: 'My Title', description: 'My Text', closed: false, reporter_id: 1 }
  end
  let(:user_bob) { { email: 'bob@example.com', password: '234&098qtpg9a732' } }
  let(:user_jane) { { email: 'jane@example.com', password: '=45y8hj@pob#n8e4' } }

  it { should belong_to(:reporter) }
  it { should belong_to(:assignee) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:reporter_id) }
  it { should validate_presence_of(:description) }

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
      expect(bug.errors[:title][0]).to(eq "can't be blank")
    end

    it 'is invalid without a reporter_id' do
      valid_attributes[:reporter_id] = nil
      bug = Bug.new(valid_attributes)
      bug.valid?
      expect(bug.errors[:reporter_id][0]).to(eq "can't be blank")
    end

    it 'is invalid without a description' do
      valid_attributes[:description] = nil
      bug = Bug.new(valid_attributes)
      bug.valid?
      expect(bug.errors[:description][0]).to(eq "can't be blank")
    end
  end

  context 'with valid or invalid User associations' do
    before(:example) do
      valid_attributes[:reporter_id] = nil
      @bug = Bug.new(valid_attributes)
    end

    it 'is valid if reporter record is valid' do
      @bug.create_reporter!(user_jane)
      @bug.valid?
      expect(@bug).to(be_valid)
    end

    it 'is valid if assignee record is valid' do
      @bug.create_reporter!(user_bob)
      @bug.create_assignee!(user_jane)
      @bug.valid?
      expect(@bug).to(be_valid)
    end

    it 'is invalid if reporter record is invalid' do
      @bug.build_reporter(id: 9999, email: nil)
      @bug.save
      expect(@bug.errors[:reporter][0]).to(eq 'is invalid')
    end

    it 'is invalid if assignee record is invalid' do
      @bug.build_assignee(id: 9999, email: nil)
      @bug.save
      expect(@bug.errors[:assignee][0]).to(eq 'is invalid')
    end
  end
end
