require 'rails_helper'

RSpec.describe 'bugs/new', type: :view do
  before(:example) do
    bug_new = Bug.new
    bug_new.build_reporter(email: 'jane@example.com', password: '29funaoiw3fuq345!@')
    assign :bug, bug_new
    render
  end

  it 'renders the _bug_form partrial' do
    expect(view).to render_template(partial: '_bug_form', count: 1)
  end

  it 'renders the bug form and all its fields' do
    assert_select 'form[action=?][method=?]', bugs_path, 'post' do
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
end
