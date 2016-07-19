require 'rails_helper'

# TODO: tests for tags, assignment (with / without)

RSpec.describe 'bugs/index', type: :view do
  # This should return the minimal set of attributes required to create a valid
  # Bug. Remember to keep this up to date (or better, switch to fixtures or FactoryGirl).
  let(:valid_attributes) {
    {
      title: 'My Title',
      description: 'My Text',
      closed: false,
      reporter_id: 1
    }
  }

  context 'with 0 bugs' do
    before(:each) do
      # NOTE: see https://github.com/rspec/rspec-rails/issues/396
      view.lookup_context.prefixes << 'application'
      assign(:bugs, [])
    end

    it 'has a "No Bugs!" heading' do
      render
      assert_select 'h1', 'You’ve Got No Bugs!'
    end

    it 'does not render a table of bugs' do
      render
      assert_select 'table', 0
    end

    it 'renders an info notification that there are no bugs' do
      render
      assert_select 'div.panel-info > .panel-heading > .panel-title', {
        text: 'Nothing to See Here',
        count: 1
      }
      assert_select 'div.panel-info > .panel-body', {
        text: 'You don’t have any bugs yet. Click a “New Bug” button to create one.',
        count: 1
      }
    end
  end

  context 'with 1 bug' do
    before(:each) do
      assign(:bugs, [Bug.create!(valid_attributes)])
    end

    it 'has a "1 Bug" heading' do
      render
      assert_select 'h1', 'You’ve Got 1 Bug'
    end
  end

  context 'with 2 bugs' do
    before(:each) do
      bugs = []
      2.times { bugs << Bug.create!(valid_attributes) }
      assign(:bugs, bugs)
    end

    it 'has a "2 Bugs" heading' do
      render
      assert_select 'h1', 'You’ve Got 2 Bugs'
    end

    it 'displays appropriate table headings' do
      render
      assert_select 'thead th:nth-child(1)', { text: 'ID', count: 1 }
      assert_select 'thead th:nth-child(2)', { text: 'Title', count: 1 }
      assert_select 'thead th:nth-child(3)', { text: 'Assignee', count: 1 }
      assert_select 'thead th:nth-child(4)', { text: 'Tags', count: 1 }
      assert_select 'thead th:nth-child(5)', { text: 'Closed?', count: 1 }
      assert_select 'thead th:nth-child(6)', { text: 'Opened', count: 1 }
      assert_select 'thead th:nth-child(7)', { text: 'Updated', count: 1 }
      assert_select 'thead th:nth-child(8)', { text: 'Actions', count: 1 }
    end

    it 'renders a list of all bugs' do
      render
      assert_select 'tr > td:nth-child(1)', { text: /^\d+$/, count: 2 }
      assert_select 'tr > td:nth-child(2)', { text: valid_attributes[:title], count: 2 }
      assert_select 'tr > td:nth-child(3)', { text: 'unassigned', count: 2 }
      assert_select 'tr > td:nth-child(4)', { text: '', count: 2 }
      assert_select 'tr > td:nth-child(5)', { text: false.to_s, count: 2 }
      assert_select 'tr > td:nth-child(6)', { text: Time.now.strftime('%Y-%m-%d'), count: 2 }
      assert_select 'tr > td:nth-child(7)', { text: Time.now.strftime('%Y-%m-%d'), count: 2 }
      assert_select 'tr > td:nth-child(8) > a[href^="/bugs/"][href$="/edit"]', { text: 'Edit', count: 2 }
      assert_select 'tr > td:nth-child(9) > a[data-method="delete"]', { text: 'Delete', count: 2 }
    end
  end

  context 'with closed and unclosed bugs' do
    before(:each) do
      bugs = []
      [true, false].each do |b|
        valid_attributes[:closed] = b
        bugs << Bug.create!(valid_attributes)
      end
      assign(:bugs, bugs)
    end

    it 'wraps closed bug titles in <s> tag' do
      render
      assert_select 'tr > td:nth-child(2)', { text: valid_attributes[:title], count: 2 }
      assert_select 'tr > td:nth-child(2) s', { text: valid_attributes[:title], count: 1 }
    end

    it 'gives the "bg-success" class to "Closed?" cell for closed bugs' do
      render
      assert_select 'tr > td:nth-child(5).bg-success', { text: true.to_s, count: 1 }
    end

    it 'gives the "bg-danger" class to "Closed?" cell for unclosed bugs' do
      render
      assert_select 'tr > td:nth-child(5).bg-danger', { text: false.to_s, count: 1 }
    end
  end
end
