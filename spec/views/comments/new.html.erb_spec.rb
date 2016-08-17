# require 'rails_helper'
#
# RSpec.describe "comments/new", type: :view do
#   before(:example) do
#     assign(:comment, Comment.new(
#       :body => "MyText",
#       :bug => nil,
#       :author => nil
#     ))
#   end
#
#   it "renders new comment form" do
#     render
#
#     assert_select "form[action=?][method=?]", comments_path, "post" do
#
#       assert_select "textarea#comment_body[name=?]", "comment[body]"
#
#       assert_select "input#comment_bug_id[name=?]", "comment[bug_id]"
#
#       assert_select "input#comment_author_id[name=?]", "comment[author_id]"
#     end
#   end
# end
