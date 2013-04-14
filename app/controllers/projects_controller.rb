class ProjectsController < ApplicationController
  load_and_authorize_resource :except => :receive_from_mapping_site
  helper_method :sort_column, :sort_direction
  layout "project", :except => [:index]

  skip_before_filter :verify_authenticity_token,  :only => [:receive_from_mapping_site]           # turn off Cross-Site Request Forgery for receive_from_mapping_site

  add_breadcrumb 'Home', '/'

  # GET /projects
  # GET /projects.json
  def index
    add_breadcrumb 'Projects'

    @projects = @projects.search(params[:search]).page(params[:page]).order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    add_breadcrumb 'Projects', projects_path
    add_breadcrumb 'New project'
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    add_breadcrumb 'Projects', :projects_path
    @step = params[:step] || '1'
    add_breadcrumb 'Edit details' if @step == '1'
    add_breadcrumb 'Edit location' if @step == '2'

  end

  # POST /projects
  # POST /projects.json
  def create
    @project.owner_id = current_user.id
    @step = params[:step] || 1

    # params[:project][:animal_ids] ||= []               # TODO: remove commented out
    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_path(@project, :step => 2), notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = @project.find(params[:id])
    @step = params[:step] || 1

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  # GET /projects/1/duplicate
  def duplicate
    @project_dup = @project.dup
    @project_dup.name << ' (duplicated)'
    # TODO: duplicate children
    respond_to do |format|
      if @project_dup.save
        format.html { redirect_to projects_url, notice: 'Project was successfully duplicated.' }
      else
        format.html { redirect_to projects_url, error: 'Could not duplicate project.' }
      end
    end

  end

  def send_to_mapping_site
    render :send_to_mapping_site, :layout => false
  end

  # Note that this method is not protected by Cancan
  def receive_from_mapping_site
    # request.referer    TODO: check referrer for cross-site forgery
    if (session[:session_id] == params[:source_id]) then
      render :receive_from_mapping_site, :layout => false
    elsif
      # Something's not right. Assume security breach (CSRF).
      sign_out :user
      render 'errors/not_authorized', :layout => false
    end
  end


  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
