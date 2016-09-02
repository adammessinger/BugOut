class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  # GET /bugs
  # GET /bugs.json
  def index
    @bugs = Bug.all.order(id: :asc)
  end

  # GET /bugs/1
  # GET /bugs/1.json
  def show
  end

  # GET /bugs/new
  def new
    @bug = Bug.new(reporter_id: current_user.id)
  end

  # GET /bugs/1/edit
  def edit
    return redirect_unauthorized(__method__) unless authorized?

    # TODO: implement soft delete of user records so this isn't necessary.
    @bug.reporter = @bug.reporter.nil? ? current_user : @bug.reporter
  end

  # POST /bugs
  # POST /bugs.json
  def create
    @bug = Bug.new(bug_params)

    respond_to do |format|
      if @bug.save
        format.html { redirect_to @bug, success: 'Bug was successfully created.' }
        format.json { render :show, status: :created, location: @bug }
      else
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bugs/1
  # PATCH/PUT /bugs/1.json
  def update
    return redirect_unauthorized(__method__) unless authorized?

    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to @bug, success: 'Bug was successfully updated.' }
        # format.json { render :show, status: :ok, location: @bug }
      else
        format.html { render :edit }
        # format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bugs/1
  # DELETE /bugs/1.json
  def destroy
    if @bug.assignee_or_comments?
      return redirect_unauthorized(:delete, 'You can’t delete a bug that’s been assigned or has comments.')
    end
    return redirect_unauthorized(:delete) unless authorized?

    @bug.destroy
    respond_to do |format|
      format.html { redirect_to bugs_url, success: 'Bug was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bug
    @bug = Bug.find(params[:id])
  end

  def redirect_unauthorized(action, error_msg = nil)
    error_msg ||= "Only a bug’s reporter or assignee (or an admin) can #{action} it."
    redirect_to @bug, error: error_msg
  end

  def authorized?
    user_signed_in? && @bug.owned_by?(current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bug_params
    params.require(:bug).permit(:reporter_id, :assignee_id, :title, :description, :tags, :closed)
  end
end
