class FieldsController < ApplicationController

  include Mycalculations
  include Ntt

  load_and_authorize_resource :farm
  load_and_authorize_resource :field, :through => :farm
  layout 'farm', :only => [:index]

  add_breadcrumb 'Home', '/'
  add_breadcrumb 'Farms', :farms_path


  # GET /farms/1/fields
  # GET /farms/1/fields.json
  def index

    # @farm = Project.find(params[:farm_id])
    # @fields = @farm.fields
    add_breadcrumb @farm.code, farm_path(@farm)
    add_breadcrumb 'Fields'

    # natural sort fields
    @fields = Naturalsorter::Sorter.sort_by_method(@fields, :name, true)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /farms/1/fields/1
  # GET /farms/1/fields/1.json
  def show

    # there is no screen to show a field, just edit
    redirect_to :action => 'edit'

    # @farm = Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    #add_breadcrumb @farm.name, farm_path(@farm)
    #add_breadcrumb 'Fields', farm_fields_path(@farm)
    #add_breadcrumb @field.name

    #respond_to do |format|
    #  format.html # show.html.erb
    #end
  end

  # GET /farms/1/fields/new
  # GET /farms/1/fields/new.json
  def new
    # @farm = Project.find(params[:farm_id])
    # @field =@farm.fields.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /farms/1/fields/1/edit
  def edit

    add_breadcrumb @farm.code, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name
    # @farm= Project.find(params[:farm_id])
    # @field = @farm.fields.find(params[:id])
    @step = params[:step] || '1'

    @soil_test_laboratories = SoilTestLaboratory.where(:state_id => @farm.site_state_id) if @step == '2'

    if session[:debug]
    success, content = buildXml(@field)    # TODO: remove/change
    @input_xml = content    # TODO: remove/change
    success, content =  callNtt(@field)    # TODO: remove/change
    if (success)
      @results = Hash.from_xml((content.xpath('//Results')).to_s)['Results']
      @output_xml = content
      if (@results['ErrorCode'] != '0')
        flash[:error] = 'Could not retrieve NTT info: ' << @results['ErrorDes']     # TODO: check for error!
      end
    else
      flash[:error] = 'Could not contact NTT: ' << content.to_s
    end
      end

  end

  # POST /farms/1/fields
  # POST /farms/1/fields.json
  def create
    #  @farm = Project.find(params[:farm_id])
    # @field =@farm.fields.build(params[:field])

    respond_to do |format|
      if @field.save
        format.html { redirect_to farm_field_url(@farm, @field), notice: 'Field was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /farms/1/fields/1
  # PUT /farms/1/fields/1.json
  def update

    add_breadcrumb @farm.name, farm_path(@farm)
    add_breadcrumb 'Fields', farm_fields_path(@farm)
    add_breadcrumb @field.name

    # TODO: exception handling
    ################################################################
    ################################################################
    isOk = true
    begin
    calculations(@field)    # TEST@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    rescue
      isOk = false
    end
    ################################################################
    ################################################################

    # @farm =Project.find(params[:farm_id])
    # field = @farm.fields.find(params[:id])
    @step = params[:field][:step] || '1'

    respond_to do |format|
      if @field.update_attributes(params[:field])
        # if step 2 and the user click 'add a crop to rotation'
        if !params[:addCropForStrip].blank?
          strip_index = params[:addCropForStrip].to_i
          format.html { redirect_to new_farm_field_strip_crop_rotation_url(@farm, @field, @field.strips[strip_index]), notice: 'Field was successfully updated.' }
        elsif (@step=='2' && @field.field_type.id == 5)     # non-managed land and step 2: got back to farm summary
          format.html { redirect_to farm_url(@farm), notice: 'Field was successfully updated.' }
        else
          format.html { redirect_to edit_farm_field_url(@farm, @field, :step => @step.to_i+1), notice: 'Field was successfully updated.' }
        end
      else  # error
        @soil_test_laboratories = SoilTestLaboratory.where(:state_id => @farm.site_state_id) if @step == '2'
        format.html { render action: 'edit'}
      end
    end
  end

  # DELETE /farms/1/fields/1
  # DELETE /farms/1/fields/1.json
  def destroy
    @farm= Farm.find(params[:farm_id])
    @field = @farm.fields.find(params[:id])
    @field.destroy

    respond_to do |format|
      format.html { redirect_to farm_path(@farm) }
    end
  end

  # POST /farms/1/fields/1/export
  def export
    # copy all the strips from field A to field B
    @to_field_id = params[:export_to_field_id].to_i

    # delete all the existing strips for field B
    @to_field = @farm.fields.find{|f| f["id"] == @to_field_id}
    @to_field.strips.destroy_all

    # copy strips from A to B
    is_success = true
      @field.strips.each do |strip|
        @strip_dup = strip.amoeba_dup
        @strip_dup.field_id = @to_field_id
        if !@strip_dup.save!(:validate => false)
          is_success = false
        end

      end

    respond_to do |format|
    if is_success
      format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Export successful.' }
    else
      format.html { redirect_to edit_farm_field_path(@farm, @field, :step => 3), notice: 'Error: could not export.' }
    end
      end
  end

end
