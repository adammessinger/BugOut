# require 'rails_helper'
#
# RSpec.describe "comments/edit", type: :view do
#   before(:example) do
#     @comment = assign(:comment, Comment.create!(
#       :body => "MyText",
#       :bug => nil,
#       :author => nil
#     ))
#   end
#
#   it "renders the edit comment form" do
#     render
#
#     assert_select "form[action=?][method=?]", comment_path(@comment), "post" do
#
#       assert_select "textarea#comment_body[name=?]", "comment[body]"
#
#       assert_select "input#comment_bug_id[name=?]", "comment[bug_id]"
#
#       assert_select "input#comment_author_id[name=?]", "comment[author_id]"
#     end
#   end
# end
