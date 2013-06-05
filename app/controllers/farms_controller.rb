class FarmsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  layout "farm", :except => [:index]

  skip_before_filter :verify_authenticity_token, :only => [:receive_from_mapping_site] # turn off Cross-Site Request Forgery for receive_from_mapping_site

  add_breadcrumb 'Home', '/'

  # GET /farms
  # GET /farms.json
  def index
    add_breadcrumb 'Farms'

    @farms = @farms.search(params[:search]).page(params[:page]).order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @farms }
    end
  end

  # GET /farms/1
  # GET /farms/1.json
  def show
    add_breadcrumb 'Farms', :farms_path
    add_breadcrumb @farm.code

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @farm }
    end
  end

  # GET /farms/new
  # GET /farms/new.json
  def new
    add_breadcrumb 'Farms', :farms_path
    add_breadcrumb 'New farm'
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @farm }
    end
  end

  # GET /farms/1/edit
  def edit
    add_breadcrumb 'Farms', :farms_path
    add_breadcrumb @farm.code

    @step = params[:step] || '1'
    add_breadcrumb 'Edit details' if @step == '1'
    add_breadcrumb 'Edit location' if @step == '2'

  end

  # POST /farms
  # POST /farms.json
  def create
    @farm.owner_id = current_user.id
    @step = params[:step] || 1

    # params[:farm][:animal_ids] ||= []               # TODO: remove commented out
    respond_to do |format|
      if @farm.save
        format.html { redirect_to edit_farm_path(@farm, :step => 2), notice: 'Farm was successfully created.' }
        format.json { render json: @farm, status: :created, location: @farm }
      else
        format.html { render action: "new" }
        format.json { render json: @farm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /farms/1
  # PUT /farms/1.json
  def update
    # @farm = @farm.find(params[:id])
    @next_step = (params[:step] || 1).to_i + 1

    respond_to do |format|
      if @farm.update_attributes(params[:farm])
        format.html { redirect_to edit_farm_path(@farm, :step => @next_step), notice: 'Farm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @farm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /farms/1
  # DELETE /farms/1.json
  def destroy
    @farm.destroy

    respond_to do |format|
      format.html { redirect_to farms_url }
      format.json { head :no_content }
    end
  end

  # POST /farms/1/duplicate
  def duplicate
    @farm_dup = @farm.dup :include => [:fields, :animals]
    @farm_dup.name << ' (duplicated)'

    respond_to do |format|
      if @farm_dup.save
        format.html { redirect_to farms_url, notice: 'Farm was successfully duplicated.' }
      else
        format.html { redirect_to farms_url, error: 'Could not duplicate farm.' }
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

      #######################

      # step 1: delete fields not found
      @farm.fields.each do |field|
        isFound = false
        for i in 1..params[:fieldnum].to_i
          if (field.name == params["field#{i}id"]) then
            isFound = true
          end
        end
        if (!isFound) then
          field.destroy()
        end
      end

      # step 2: update or create remaining fields
      for i in 1..params[:fieldnum].to_i
        # find or create
        @field = @farm.fields.where(:name => params["field#{i}id"]).first || @farm.fields.build(:name => params["field#{i}id"])
        @field.coordinates = params["field#{i}coords"]
        @field.acres_from_map = params["field#{i}acres"]
        @field.segment_id = params["field#{i}segment"]
        @field.tmdl_watershed = (params["field#{i}tmdl"] != 'none')

        # get the top 3 soils



        arrFieldpctsoiltype = params["field#{i}pctsoiltype"].split("|")
        arrFieldmukey = params["field#{i}mukey"].split("|")
        arrFieldcompname = params["field#{i}compname"].split("|")
        arrFieldmuname  = params["field#{i}muname"].split("|")

        @listSoils = Array.new

        arrFieldpctsoiltype.each_with_index do |fieldpctsoiltype, index|
          @listSoils << {
              :percent =>  arrFieldpctsoiltype[index],
              :mukey =>  arrFieldmukey[index],
              :compname => arrFieldcompname[index],
              :muname => arrFieldmuname[index]
          }
        end

        # sort by percentage in descending order
        @listSoils = @listSoils.sort_by!{|e| e[:percent]}.reverse!

        # at most 3 soils are displayed
        @nbSoils = [3, @listSoils.length].min
        @nbSoils = 2

        # TODO: delete only if necessary
        @field.soils.destroy_all

        @nbSoils.times do
          @field.soils.build
        end


        (0..@nbSoils-1).each do |i|
          @field.soils[i].percent = @listSoils[i][:percent]
          @field.soils[i].mukey = @listSoils[i][:mukey]
          @field.soils[i].compname = @listSoils[i][:compname]
          @field.soils[i].muname = @listSoils[i][:muname]
        end

        @field.save(:validate => false)
      end

      @farm.coordinates = params[:parcelcoords]
      @farm.acres = params[:parcelacres]
      @farm.save
      #######################

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
