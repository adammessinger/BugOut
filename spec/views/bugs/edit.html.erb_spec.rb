require 'rails_helper'

RSpec.describe 'bugs/edit', type: :view do
  let(:valid_attributes) {
    {
      title: 'My Title',
      description: 'My Text',
      reporter_id: 1
    }
  }
  let(:complete_attributes) {
    {
      title: 'Title',
      description: 'My Text',
      closed: false,
      tags: 'foo, bar, baz'
    }
  }

  context 'with a complete bug' do
    before(:example) do
      bug_c = Bug.new(complete_attributes)
      reporter = User.create!(email: 'jon@example.com', password: '29funaoiw3fuq345!@')
      assignee = User.create!(email: 'jane@example.com', password: '29funaoiw3fuq345!@')
      bug_c.update(reporter_id: reporter.id, assignee_id: assignee.id)
      @complete_bug = assign :bug, bug_c
      render
    end

    it 'renders the _bug_form partrial' do
      expect(view).to render_template(partial: '_bug_form', count: 1)
    end

    it 'renders new bug form and all its fields' do
      assert_select 'form[action=?][method=?]', bug_path(@complete_bug), 'post' do
        assert_select 'input#bug_title[name=?]', 'bug[title]'
        assert_select 'select#bug_reporter_id[name=?]', 'bug[reporter_id]'
        assert_select 'select#bug_assignee_id[name=?]', 'bug[assignee_id]'
        assert_select 'textarea#bug_description[name=?]', 'bug[description]'
        assert_select 'input#bug_tags[name=?]', 'bug[tags]'
        assert_select 'input#bug_closed[name=?]', 'bug[closed]'
        assert_select 'input[type=submit].btn-primary[name=?]', 'commit'
      end
    end

    it 'has values in fields with data' do
      assert_select 'form[action=?][method=?]', bug_path(@complete_bug), 'post' do
        assert_select 'input#bug_title[value=?]', @complete_bug.title
        assert_select 'select#bug_reporter_id > option[selected][value=?]', @complete_bug.reporter_id.to_s
        assert_select 'select#bug_assignee_id > option[selected][value=?]', @complete_bug.assignee_id.to_s
        assert_select 'textarea#bug_description', text: @complete_bug.description
        assert_select 'input#bug_tags[value=?]', @complete_bug.tags

        # TODO: Figure out how to test checkbox value and why it's always 1 in rendered HTML.
        assert_select 'input#bug_closed[type=checkbox][checked]', (@complete_bug.closed ? 1 : 0)
      end
    end
  end

  context 'with a valid but incomplete bug' do
    before(:example) do
      bug_p = Bug.new(valid_attributes)
      reporter = User.create!(email: 'sally@example.org', password: '2p39@4hal$f8h3noiu-&nae4y')
      bug_p.update(reporter_id: reporter.id)
      @partial_bug = assign :bug, bug_p
      render
    end

    it 'renders the _bug_form partrial' do
      expect(view).to render_template(partial: '_bug_form', count: 1)
    end

    it 'has values ONLY in fields with data' do
      assert_select 'form[action=?][method=?]', bug_path(@partial_bug), 'post' do
        assert_select 'input#bug_title[value=?]', @partial_bug.title
        assert_select 'select#bug_reporter_id > option[selected][value=?]', @partial_bug.reporter_id.to_s
        assert_select 'select#bug_assignee_id > option[selected]', 0
        assert_select 'textarea#bug_description', text: @partial_bug.description
        assert_select 'input#bug_tags', 1
        assert_select 'input#bug_tags[value]', 0
        assert_select 'input#bug_closed[type=checkbox][checked]', (@partial_bug.closed ? 1 : 0)
      end
    end
  end
end
