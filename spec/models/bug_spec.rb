require 'rails_helper'

describe Bug, type: :model do
  let(:valid_attributes) do
    { title: 'My Title', description: 'My Text', closed: false, reporter_id: 1 }
  end

  it { should belong_to(:reporter) }
  it { should belong_to(:assignee) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:reporter_id) }
  it { should validate_presence_of(:description) }

  context 'with valid and invalid User associations' do
    before(:example) do
      valid_attributes[:reporter_id] = nil
      @bug = Bug.new(valid_attributes)
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
