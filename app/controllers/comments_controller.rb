class CommentsController < ApplicationController
  before_action :set_bug
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = @bug.comments
  end

  def show
  end

  def new
    @comment = Comment.new(author_id: current_user.id, bug_id: @bug.id)
  end

  def edit
  end

  def create
    @comment = @bug.comments.create(comment_params)

    if @comment.save
      redirect_to @bug, notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @bug, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @bug, notice: 'Comment was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bug
    @bug = Bug.find(params[:bug_id])
  end

  def set_comment
    @comment = @bug.comments.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:author_id, :bug_id, :body)
  end
end
