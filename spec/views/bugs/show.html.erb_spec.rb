require 'rails_helper'

RSpec.describe 'bugs/show', type: :view do
  before(:example) do
    complete_bug = Bug.new({
      title: 'Title',
      description: 'MyText',
      closed: false,
      tags: 'foo, bar, baz'
    })
    complete_bug.create_assignee email: 'jon@example.com', password: '29funaoiw3fuq345!@'
    complete_bug.create_reporter email: 'jane@example.com', password: '29funaoiw3fuq345!@'
    complete_bug.save
    assign :bug, complete_bug
    render
  end

  it 'renders bug attributes in a <dl>' do
    expect(rendered).to(match(/Title/))
    expect(rendered).to(match(/MyText/))
    expect(rendered).to(match(/false/))
    expect(rendered).to(match(/jon@example.com/))
    expect(rendered).to(match(/jane@example.com/))
    expect(rendered).to(match(/foo, bar, baz/))
  end
end
