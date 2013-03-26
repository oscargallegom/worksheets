class FieldsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :through => :project

  # GET /projects/1/fields
  # GET /projects/1/fields.json
  def index
    # @project = Project.find(params[:project_id])
    # @fields = @project.fields

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fields }
    end
  end

  # GET /projects/1/fields/1
  # GET /projects/1/fields/1.json
  def show
    # @project = Project.find(params[:project_id])
    # @field = @project.fields.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @field }
    end
  end

  # GET /projects/1/fields/new
  # GET /projects/1/fields/new.json
  def new
    # @project = Project.find(params[:project_id])
    # @field =@project.fields.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @field }
    end
  end

  # GET /projects/1/fields/1/edit
  def edit
    # @project= Project.find(params[:project_id])
    # @field = @project.fields.find(params[:id])
    @step = params[:step] || '1'

  end

  # POST /projects/1/fields
  # POST /projects/1/fields.json
  def create
    #  @project = Project.find(params[:project_id])
    # @field =@project.fields.build(params[:field])

    respond_to do |format|
      if @field.save
        format.html { redirect_to project_field_url(@project, @field), notice: 'Field was successfully created.' }
        format.json { render json: @field, status: :created, location: @field }
      else
        format.html { render action: "new" }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1/fields/1
  # PUT /projects/1/fields/1.json
  def update
    # @project =Project.find(params[:project_id])
    # field = @project.fields.find(params[:id])

    respond_to do |format|
      if @field.update_attributes(params[:field])
        format.html { redirect_to project_field_url(@project, @field), notice: 'Field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/fields/1
  # DELETE /projects/1/fields/1.json
  def destroy
    @project= Project.find(params[:project_id])
    @field = @project.fields.find(params[:id])
    @field.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.json { head :no_content }
    end
  end
end
