require 'rails_helper'

RSpec.describe 'bugs/edit', type: :view do
  context 'with a complete bug' do
    before(:example) do
      bug_c = create(:bug, tags: 'foo, bar, baz', assignee: create(:user))
      @complete_bug = assign :bug, bug_c
      render
    end

    it 'renders the _bug_form partrial' do
      expect(view).to render_template(partial: '_bug_form', count: 1)
    end

    it 'renders the bug form and all its fields' do
      assert_select 'form[action=?][method=?]', bug_path(@complete_bug), 'post' do
        assert_select 'input#bug_title[name=?]', 'bug[title]'
        assert_select 'input[type="hidden"]#bug_reporter_id[name=?]', 'bug[reporter_id]'
        assert_select 'p.form-control-static#bug_reporter', count: 1
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
        assert_select 'input[type="hidden"]#bug_reporter_id[value=?]', @complete_bug.reporter_id.to_s
        assert_select 'p#bug_reporter', @complete_bug.reporter.email
        assert_select 'select#bug_assignee_id > option[selected][value=?]', @complete_bug.assignee_id.to_s
        assert_select 'textarea#bug_description', text: @complete_bug.description
        assert_select 'input#bug_tags[value=?]', @complete_bug.tags
        assert_select 'input#bug_closed[type=checkbox][checked]', (@complete_bug.closed ? 1 : 0)
      end
    end
  end

  context 'with a valid but incomplete bug' do
    before(:example) do
      bug_p = create(:bug, closed: nil)
      @partial_bug = assign :bug, bug_p
      render
    end

    it 'renders the _bug_form partrial' do
      expect(view).to render_template(partial: '_bug_form', count: 1)
    end

    it 'has values ONLY in fields with data' do
      assert_select 'form[action=?][method=?]', bug_path(@partial_bug), 'post' do
        assert_select 'input#bug_title[value=?]', @partial_bug.title
        assert_select 'input[type="hidden"]#bug_reporter_id[value=?]', @partial_bug.reporter_id.to_s
        assert_select 'p#bug_reporter', @partial_bug.reporter.email
        assert_select 'select#bug_assignee_id > option[selected]', 0
        assert_select 'textarea#bug_description', text: @partial_bug.description
        assert_select 'input#bug_tags', 1
        assert_select 'input#bug_tags[value]', 0
        assert_select 'input#bug_closed[type=checkbox][checked]', (@partial_bug.closed ? 1 : 0)
      end
    end
  end
end
