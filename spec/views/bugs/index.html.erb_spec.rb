require 'rails_helper'

RSpec.describe 'bugs/index', type: :view do
  # This should return the minimal set of attributes required to create a valid
  # Bug. Remember to keep this up to date (or better, switch to fixtures or FactoryGirl).
  let(:valid_attributes) do
    { title: 'My Title', description: 'My Text', closed: false, reporter_id: 1 }
  end

  context 'with 0 bugs' do
    before(:example) do
      # NOTE: see https://github.com/rspec/rspec-rails/issues/396
      view.lookup_context.prefixes << 'application'
      assign :bugs, []
      render
    end

    it 'has a "No Bugs!" heading' do
      assert_select 'h1', 'You’ve Got No Bugs!'
    end

    it 'does not render a table of bugs' do
      assert_select 'table', 0
    end

    it 'renders an info notification that there are no bugs' do
      assert_select 'div.panel-info > .panel-heading > .panel-title',
        text: 'Nothing to See Here',
        count: 1
      assert_select 'div.panel-info > .panel-body',
        text: 'You don’t have any bugs yet. Click a “Report Bug” button to create one.',
        count: 1
    end
  end

  context 'with 1 bug' do
    before(:example) do
      assign :bugs, [Bug.create!(valid_attributes)]
      render
    end

    it 'has a "1 Bug" heading' do
      assert_select 'h1', 'You’ve Got 1 Bug'
    end
  end

  context 'with 2 bugs' do
    before(:example) do
      bugs = []
      2.times { bugs << Bug.create!(valid_attributes) }
      assign :bugs, bugs
      render
    end

    it 'has a "2 Bugs" heading' do
      assert_select 'h1', 'You’ve Got 2 Bugs'
    end

    it 'displays appropriate table headings' do
      assert_select 'thead th:nth-child(1)', text: 'ID', count: 1
      assert_select 'thead th:nth-child(2)', text: 'Title', count: 1
      assert_select 'thead th:nth-child(3)', text: 'Assignee', count: 1
      assert_select 'thead th:nth-child(4)', text: 'Tags', count: 1
      assert_select 'thead th:nth-child(5)', text: 'Closed?', count: 1
      assert_select 'thead th:nth-child(6)', text: 'Opened', count: 1
      assert_select 'thead th:nth-child(7)', text: 'Updated', count: 1
      assert_select 'thead th:nth-child(8)', text: 'Actions', count: 1
    end

    it 'renders a list of all bugs' do
      assert_select 'tr > td:nth-child(1)', text: /^\d+$/, count: 2
      assert_select 'tr > td:nth-child(2)', text: valid_attributes[:title], count: 2
      assert_select 'tr > td:nth-child(3)', text: 'unassigned', count: 2
      assert_select 'tr > td:nth-child(4)', text: '', count: 2
      assert_select 'tr > td:nth-child(5)', text: 'No', count: 2
      assert_select 'tr > td:nth-child(6)', text: Time.now.strftime('%Y-%m-%d'), count: 2
      assert_select 'tr > td:nth-child(7)', text: Time.now.strftime('%Y-%m-%d'), count: 2
      assert_select 'tr > td:nth-child(8) > a[href^="/bugs/"][href$="/edit"]', text: 'Edit', count: 2
      assert_select 'tr > td:nth-child(9) > a[data-method="delete"]', text: 'Delete', count: 2
    end
  end

  context 'with closed and unclosed bugs' do
    before(:example) do
      bugs = []
      [true, false].each do |b|
        valid_attributes[:closed] = b
        bugs << Bug.create!(valid_attributes)
      end
      assign :bugs, bugs
      render
    end

    it 'wraps closed bug titles in <s> tag' do
      assert_select 'tr > td:nth-child(2)', text: valid_attributes[:title], count: 2
      assert_select 'tr > td:nth-child(2) s', text: valid_attributes[:title], count: 1
    end

    it 'gives the "bg-success" class to "Closed?" cell for closed bugs' do
      assert_select 'tr > td:nth-child(5).bg-success', text: 'Yes', count: 1
    end

    it 'gives the "bg-danger" class to "Closed?" cell for unclosed bugs' do
      assert_select 'tr > td:nth-child(5).bg-danger', text: 'No', count: 1
    end
  end

  context 'with tagged and untagged bugs' do
    before(:example) do
      bugs = []
      ['urgent, wibbly, cromulent', nil].each do |t|
        valid_attributes[:tags] = t
        bugs << Bug.create!(valid_attributes)
      end
      assign :bugs, bugs
      render
    end

    it 'shows tags in table for tagged bugs' do
      assert_select 'tr > td:nth-child(4)', text: 'urgent, wibbly, cromulent', count: 1
    end

    it 'shows empty string in table for untagged bugs' do
      assert_select 'tr > td:nth-child(4)', text: '', count: 1
    end
  end

  context 'with assigned and unassigned bugs' do
    before(:example) do
      assigned_bug = Bug.new(valid_attributes)
      assigned_bug.create_assignee! email: 'jon@example.com', password: '29funaoiw3fuq345!@'
      assigned_bug.save!
      assign :bugs, [assigned_bug, Bug.create!(valid_attributes)]
      render
    end

    it 'shows asignee email address for assigned bugs' do
      assert_select 'tr > td:nth-child(3)', text: 'jon@example.com', count: 1
    end

    it 'gives no class to assigned Asignee cell' do
      assert_select 'tr > td:nth-child(3)[class=""]', text: 'jon@example.com', count: 1
    end

    it 'shows "unassigned" for unassigned bugs' do
      assert_select 'tr > td:nth-child(3)', text: 'unassigned', count: 1
    end

    it 'gives "bg-warning" & "text-warning" classes to unassigned Asignee cell' do
      assert_select 'tr > td:nth-child(3).bg-warning.text-warning', text: 'unassigned', count: 1
    end
  end
end
