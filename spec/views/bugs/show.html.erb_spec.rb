require 'rails_helper'

RSpec.describe 'bugs/show', type: :view do
  let(:complete_attributes) do
    { title: 'Title', description: 'My description', closed: false, tags: 'foo, bar, baz' }
  end

  context 'with a complete bug' do
    before(:example) do
      bug_c = Bug.new(complete_attributes)
      bug_c.create_assignee! email: 'jon@example.com', password: '29funaoiw3fuq345!@'
      bug_c.create_reporter! email: 'jane@example.com', password: '29funaoiw3fuq345!@'
      bug_c.save!
      @complete_bug = assign :bug, bug_c
      @is_closed = tf_to_yn @complete_bug.closed
      render
    end

    it 'renders bug attributes in a <dl>' do
      expect(rendered).to(match(/<h1>\s*?##{@complete_bug.id}:\s+?#{@complete_bug.title}\s*?<\/h1>/))
      expect(rendered).to(match(/<dt>Description:<\/dt>\s+?<dd>#{@complete_bug.description}<\/dd>/))
      expect(rendered).to(match(/<dt>Closed:<\/dt>\s+?<dd>\s+?<span class=".+?">\s+?#{@is_closed}\s+?<\/span>\s+?<\/dd>/))
      # NOTE: Reporter and Assignee use a different regex from Closed for the inner
      # span class because they lack a span class when those attributes have a value.
      expect(rendered).to(match(/<dt>Reporter:<\/dt>\s+?<dd>\s+?<span class="">\s+?#{@complete_bug.reporter.email}\s+?<\/span>\s+?<\/dd>/))
      expect(rendered).to(match(/<dt>Assignee:<\/dt>\s+?<dd>\s+?<span class="">\s+?#{@complete_bug.assignee.email}\s+?<\/span>\s+?<\/dd>/))
      expect(rendered).to(match(/<dt>Tags:<\/dt>\s+?<dd>#{@complete_bug.tags}<\/dd>/))
    end
  end

  context 'with an unassigned bug' do
    before(:example) do
      bug_ua = Bug.new(complete_attributes)
      bug_ua.create_reporter! email: 'jose@example.com', password: 'pq48hunavb7a0973'
      bug_ua.save!
      @unassigned_bug = assign :bug, bug_ua
      render
    end

    it 'reports the bug as "unassigned"' do
      expect(rendered).to(match(/<dt>Assignee:<\/dt>\s+?<dd>\s+?<span class=".*?">\s+?unassigned\s+?<\/span>\s+?<\/dd>/))
    end

    it 'gives "bg-warning" and "text-warning" classes to the "unassigned" indicator' do
      expect(rendered).to(match(/<dt>Assignee:<\/dt>\s+?<dd>\s+?<span class="bg-warning text-warning">/))
    end
  end

  context 'with an unclosed bug' do
    before(:example) do
      bug_uncl = Bug.new(complete_attributes)
      bug_uncl.create_reporter! email: 'jose@example.com', password: 'pq48hunavb7a0973'
      bug_uncl.save!
      @unclosed_bug = assign :bug, bug_uncl
      @is_closed = tf_to_yn @unclosed_bug.closed
      render
    end

    it 'gives the "bg-danger" class to the displayed "Closed" status' do
      expect(rendered).to(match(/<dt>Closed:<\/dt>\s+?<dd>\s+?<span class="bg-danger">\s+?#{@is_closed}\s+?<\/span>\s+?<\/dd>/))
    end
  end

  context 'with a closed bug' do
    before(:example) do
      closed_atts = complete_attributes.dup
      closed_atts[:closed] = true
      bug_cl = Bug.new(closed_atts)
      bug_cl.create_reporter! email: 'jose@example.com', password: 'pq48hunavb7a0973'
      bug_cl.save!
      @closed_bug = assign :bug, bug_cl
      @is_closed = tf_to_yn closed_atts[:closed]
      render
    end

    it 'gives the "bg-success" class to the displayed "Closed" status' do
      expect(rendered).to(match(/<dt>Closed:<\/dt>\s+?<dd>\s+?<span class="bg-success">\s+?#{@is_closed}\s+?<\/span>\s+?<\/dd>/))
    end
  end
end
