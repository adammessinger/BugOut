require 'rails_helper'

RSpec.describe 'bugs/show', type: :view do
  context 'with a complete bug' do
    before(:example) do
      bug_c = create(:bug, description: Faker::Lorem.paragraph(2), assignee: create(:user))
      @complete_bug = assign(:bug, bug_c)
      @is_closed = tf_to_yn(@complete_bug.closed)
      render
    end

    it 'renders bug attributes in a <dl>' do
      expect(rendered).to(match(/<h1>\s*?##{@complete_bug.id}:\s+?#{@complete_bug.title}\s*?<\/h1>/))
      expect(rendered).to(match(/<dt>Description:<\/dt>\s+?<dd>#{@complete_bug.description}<\/dd>/))
      expect(rendered).to(match(/<dt>Closed:<\/dt>\s+?<dd>\s+?<span class=".+?">\s+?#{@is_closed}\s+?<\/span>\s+?<\/dd>/))
      # NOTE: Reporter and Assignee use a different regex from Closed for the inner
      # span class because they lack a span class when those attributes have a value.
      expect(rendered).to(match(/<dt>Reporter:<\/dt>\s+?<dd>\s+?<span class="">\s+?#{@complete_bug.reporter}\s+?<\/span>\s+?<\/dd>/))
      expect(rendered).to(match(/<dt>Assignee:<\/dt>\s+?<dd>\s+?<span class="">\s+?#{@complete_bug.assignee}\s+?<\/span>\s+?<\/dd>/))
      expect(rendered).to(match(/<dt>Tags:<\/dt>\s+?<dd>#{@complete_bug.tags}<\/dd>/))
    end
  end

  context 'with an unassigned bug' do
    before(:example) do
      bug_ua = create(:bug, description: Faker::Lorem.paragraph(2))
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
      bug_uncl = create(:bug, description: Faker::Lorem.paragraph(2), closed: false)
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
      bug_cl = create(:bug, description: Faker::Lorem.paragraph(2), closed: true)
      @closed_bug = assign :bug, bug_cl
      @is_closed = tf_to_yn(bug_cl.closed)
      render
    end

    it 'gives the "bg-success" class to the displayed "Closed" status' do
      expect(rendered).to(match(/<dt>Closed:<\/dt>\s+?<dd>\s+?<span class="bg-success">\s+?#{@is_closed}\s+?<\/span>\s+?<\/dd>/))
    end
  end
end
