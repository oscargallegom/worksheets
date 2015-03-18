require 'debugger'

class FarmsController < ApplicationController

  include BmpCalculations
  include Ntt
  include ModelRun
  include BaselineCheck


  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  layout "farm", :except => [:index]

  skip_before_filter :verify_authenticity_token, :only => [:receive_from_mapping_site] # turn off Cross-Site Request Forgery for receive_from_mapping_site

  add_breadcrumb 'Home', :farms_path

  # GET /farms
  # GET /farms.json
  def index
    add_breadcrumb 'Projects'

    @farms = @farms.search(params[:search]).page(params[:page]).order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /farms/1
  # GET /farms/1.json
  def show
    add_breadcrumb 'Projects', :farms_path
    add_breadcrumb @farm.name

    @arrWatersheds = Array.new
    @arrMajorBasins = Array.new
    @arrTMDLs = Array.new

    # sort fields 'naturally'
    @fields = Naturalsorter::Sorter.sort_by_method(@farm.fields, :name, true)

    @watersheds = (@fields.collect {|x| x.watershed_segment}).uniq
    @p_factors = ((@watersheds.collect {|z| z.p_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @n_factors = ((@watersheds.collect {|z| z.n_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @s_factors = ((@watersheds.collect {|z| z.sediment_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")

    @cb_segment = ((@watersheds.collect {|z| z.key}).uniq).map {|i| i.to_s }.join(", ")

    # check if the farm meets baseline or not
    #@baseline_n_load_fields = 0
    @current_n_load_fields = 0
    @future_n_load_fields = 0

    @baseline_p_load_fields = 0
    @current_p_load_fields = 0
    @future_p_load_fields = 0

    @baseline_sediment_load_fields = 0
    @current_sediment_load_fields = 0
    @future_sediment_load_fields = 0

    @current_n_load_animals = 0
    @current_p_load_animals = 0
    @current_sediment_load_animals = 0

    @future_n_load_animals = 0
    @future_p_load_animals = 0
    @future_sediment_load_animals = 0

    @fields.each do |field|

      @arrWatersheds << field.watershed_name unless @arrWatersheds.include?(field.watershed_name)
      @arrMajorBasins << field.watershed_segment.major_basin unless field.watershed_segment.nil? || @arrMajorBasins.include?(field.watershed_segment.major_basin)
      @arrTMDLs << field.tmdl.name if @farm.site_state_id != 47 && !field.tmdl.nil? && !@arrTMDLs.include?(field.tmdl.name)
      @arrTMDLs << field.tmdl_va if @farm.site_state_id == 47 && !@arrTMDLs.include?(field.tmdl_va)

      if (!field.field_type.nil?) && (field.field_type.id == 1 || field.field_type.id == 2 || field.field_type.id == 3)
        begin
          if field.other_land_use_conversion_acres_future
            @current_totals = computeBmpCalculations(field)
            calculate_bmps_without_conversion(field)
            calculate_bmps(field)
            if @with_conversion[:sediment] > @without_conversion[:sediment]
              @current_totals[:new_total_sediment_future] = @without_conversion[:sediment]
            end
            if @with_conversion[:nitrogen] > @without_conversion[:nitrogen]
              @current_totals[:new_total_n_future] = @without_conversion[:nitrogen]
            end
            if @with_conversion[:phosphorus] > @without_conversion[:phosphorus]
              @current_totals[:new_total_p_future] = @without_conversion[:phosphorus]
            end
          else
            @current_totals = computeBmpCalculations(field)
          end
        rescue Exception => e
          flash.now[:error] = e.message
          @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0}
        end

        @current_n_load_fields += @current_totals[:new_total_n]
        @current_p_load_fields += @current_totals[:new_total_p]
        @current_sediment_load_fields += @current_totals[:new_total_sediment]

        @future_n_load_fields += @current_totals[:new_total_n_future]


        @future_p_load_fields += @current_totals[:new_total_p_future]

        @future_sediment_load_fields += @current_totals[:new_total_sediment_future]

        # watershed_segment = WatershedSegment.where(:id => field.watershed_segment_id).first
        # if (!watershed_segment.nil?)
        #   # @baseline_sediment_load_fields += watershed_segment[:sediment_crop_baseline] * field.acres / 2000.0 if field.field_type_id == 1
        #   # @baseline_sediment_load_fields += watershed_segment[:sediment_pasture_baseline] * field.acres / 2000.0 if field.field_type_id == 2
        #   # @baseline_sediment_load_fields += watershed_segment[:sediment_hay_baseline] * field.acres / 2000.0 if field.field_type_id == 3

        #   if field.tmdl.nil?
        #     #@baseline_n_load_fields += watershed_segment[:n_crop_baseline] * field.acres if field.field_type_id == 1
        #     #@baseline_n_load_fields += watershed_segment[:n_pasture_baseline] * field.acres if field.field_type_id == 2
        #     #@baseline_n_load_fields += watershed_segment[:n_hay_baseline] * field.acres if field.field_type_id == 3

        #     #@baseline_p_load_fields += watershed_segment[:p_crop_baseline] * field.acres if field.field_type_id == 1
        #     #@baseline_p_load_fields += watershed_segment[:p_pasture_baseline] * field.acres if field.field_type_id == 2
        #     #@baseline_p_load_fields += watershed_segment[:p_hay_baseline] * field.acres if field.field_type_id == 3

        #   else # use Maryland TMDL
        #     #@baseline_n_load_fields += field.tmdl[:total_n] * field.acres
        #     #@baseline_p_load_fields += field.tmdl[:total_p] * field.acres
        #   end
        # end
      end

      # animals
      if (!field.field_type.nil?) && (field.field_type.id == 4)
        @current_totals = computeLivestockBmpCalculations(field)
        @current_n_load_animals += @current_totals[:current_load_nitrogen]
        @current_p_load_animals += @current_totals[:current_load_phosphorus]
        @current_sediment_load_animals += @current_totals[:current_load_sediment]
        #future
        @future_totals = computeLivestockBmpCalculationsFuture(field)
        @future_n_load_animals += @future_totals[:current_load_nitrogen]
        @future_p_load_animals += @future_totals[:current_load_phosphorus]
        @future_sediment_load_animals += @future_totals[:current_load_sediment]
      end



    end



    @tab = params[:tab]

    respond_to do |format|
      format.html # show.html.erb   if @tab.nil?
    end
  end

  # GET/farms/id/review
  def review

    @completed = true

    add_breadcrumb 'Projects', :farms_path
    add_breadcrumb @farm.name

    @fields = Naturalsorter::Sorter.sort_by_method(@farm.fields, :name, true)

    @watersheds = (@fields.collect {|x| x.watershed_segment}).uniq
    @p_factors = ((@watersheds.collect {|z| z.p_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @n_factors = ((@watersheds.collect {|z| z.n_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @s_factors = ((@watersheds.collect {|z| z.sediment_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @arrWatersheds = Array.new
    @arrMajorBasins = Array.new
    @arrTMDLs = Array.new

    @fields.each do |field|

      @arrWatersheds << field.watershed_name unless @arrWatersheds.include?(field.watershed_name)
      @arrMajorBasins << field.watershed_segment.major_basin unless field.watershed_segment.nil? || @arrMajorBasins.include?(field.watershed_segment.major_basin)
      @arrTMDLs << field.tmdl.name if @farm.site_state_id != 47 && !field.tmdl.nil? && !@arrTMDLs.include?(field.tmdl.name)
      @arrTMDLs << field.tmdl_va if @farm.site_state_id == 47 && !@arrTMDLs.include?(field.tmdl_va)

    end

    # check if the farm meets baseline or not
    @baseline_n_load_fields = 0
    @current_n_load_fields = 0
    @future_n_load_fields = 0

    @baseline_p_load_fields = 0
    @current_p_load_fields = 0
    @future_p_load_fields = 0

    @baseline_sediment_load_fields = 0
    @current_sediment_load_fields = 0
    @future_sediment_load_fields = 0

    @current_n_load_animals = 0
    @current_p_load_animals = 0
    @current_sediment_load_animals = 0

    @future_n_load_animals = 0
    @future_p_load_animals = 0
    @future_sediment_load_animals = 0

    @farm.fields.each do |field|
      if (!field.field_type.nil?) && (field.field_type.id == 1 || field.field_type.id == 2 || field.field_type.id == 3)
        begin
          if field.other_land_use_conversion_acres_future
            @current_totals = computeBmpCalculations(field)
            calculate_bmps_without_conversion(field)
            calculate_bmps(field)
            if @with_conversion[:sediment] > @without_conversion[:sediment]
              @current_totals[:new_total_sediment_future] = @without_conversion[:sediment]
            end
            if @with_conversion[:nitrogen] > @without_conversion[:nitrogen]
              @current_totals[:new_total_n_future] = @without_conversion[:nitrogen]
            end
            if @with_conversion[:phosphorus] > @without_conversion[:phosphorus]
              @current_totals[:new_total_p_future] = @without_conversion[:phosphorus]
            end
          else
            @current_totals = computeBmpCalculations(field)
          end
        rescue Exception => e
          flash[:error] = e.message
          @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0}
        end

        @current_n_load_fields = @current_n_load_fields + @current_totals[:new_total_n]
        @current_p_load_fields = @current_p_load_fields + @current_totals[:new_total_p]
        @current_sediment_load_fields = @current_sediment_load_fields + @current_totals[:new_total_sediment]

        logger.debug "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @current_totals[:new_total_sediment] #{@current_totals[:new_total_sediment]}"
        @new_total_sediment = @current_totals[:new_total_sediment]


        @future_n_load_fields = @future_n_load_fields + @current_totals[:new_total_n_future]
        @future_p_load_fields = @future_p_load_fields + @current_totals[:new_total_p_future]
        @future_sediment_load_fields = @future_sediment_load_fields + @current_totals[:new_total_sediment_future]
        @new_total_sediment_future = @current_totals[:new_total_sediment_future]

        watershed_segment = WatershedSegment.where(:id => field.watershed_segment_id).first
        if (!watershed_segment.nil?)
          @baseline_sediment_load_fields += watershed_segment[:sediment_crop_baseline] * field.acres / 2000.0 if field.field_type_id == 1
          @baseline_sediment_load_fields += watershed_segment[:sediment_pasture_baseline] * field.acres / 2000.0 if field.field_type_id == 2
          @baseline_sediment_load_fields += watershed_segment[:sediment_hay_baseline] * field.acres / 2000.0 if field.field_type_id == 3


          if field.tmdl.nil?
            @baseline_n_load_fields += watershed_segment[:n_crop_baseline] * field.acres if field.field_type_id == 1
            @baseline_n_load_fields += watershed_segment[:n_pasture_baseline] * field.acres if field.field_type_id == 2
            @baseline_n_load_fields += watershed_segment[:n_hay_baseline] * field.acres if field.field_type_id == 3

            @baseline_p_load_fields += watershed_segment[:p_crop_baseline] * field.acres if field.field_type_id == 1
            @baseline_p_load_fields += watershed_segment[:p_pasture_baseline] * field.acres if field.field_type_id == 2
            @baseline_p_load_fields += watershed_segment[:p_hay_baseline] * field.acres if field.field_type_id == 3

          else # use Maryland TMDL
            @baseline_n_load_fields += field.tmdl[:total_n] * field.acres
            @baseline_p_load_fields += field.tmdl[:total_p] * field.acres
          end
        end
      end
      # animals
      if (!field.field_type.nil?) && (field.field_type.id == 4)
        @current_totals = computeLivestockBmpCalculations(field)
        @current_n_load_animals += @current_totals[:current_load_nitrogen]
        @current_p_load_animals += @current_totals[:current_load_phosphorus]
        @current_sediment_load_animals += @current_totals[:current_load_sediment]
        #future
        @future_totals = computeLivestockBmpCalculationsFuture(field)
        @future_n_load_animals += @future_totals[:current_load_nitrogen]
        @future_p_load_animals += @future_totals[:current_load_phosphorus]
        @future_sediment_load_animals += @future_totals[:current_load_sediment]
      end

      # @is_farm_meets_baseline = is_farm_meets_baseline(@farm)

    end
  end

  def current

    @completed = true

    add_breadcrumb 'Projects', :farms_path
    add_breadcrumb @farm.name

@fields = Naturalsorter::Sorter.sort_by_method(@farm.fields, :name, true)

    @watersheds = (@fields.collect {|x| x.watershed_segment}).uniq
    @p_factors = ((@watersheds.collect {|z| z.p_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @n_factors = ((@watersheds.collect {|z| z.n_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @s_factors = ((@watersheds.collect {|z| z.sediment_delivery_factor.round(2)}).uniq).map {|i| i.to_s }.join(", ")
    @arrWatersheds = Array.new
    @arrMajorBasins = Array.new
    @arrTMDLs = Array.new

    @fields.each do |field|

      @arrWatersheds << field.watershed_name unless @arrWatersheds.include?(field.watershed_name)
      @arrMajorBasins << field.watershed_segment.major_basin unless field.watershed_segment.nil? || @arrMajorBasins.include?(field.watershed_segment.major_basin)
      @arrTMDLs << field.tmdl.name if @farm.site_state_id != 47 && !field.tmdl.nil? && !@arrTMDLs.include?(field.tmdl.name)
      @arrTMDLs << field.tmdl_va if @farm.site_state_id == 47 && !@arrTMDLs.include?(field.tmdl_va)

    end

    # check if the farm meets baseline or not
    #@baseline_n_load_fields = 0
    @current_n_load_fields = 0
    @future_n_load_fields = 0

    @baseline_p_load_fields = 0
    @current_p_load_fields = 0
    @future_p_load_fields = 0

    @baseline_sediment_load_fields = 0
    @current_sediment_load_fields = 0
    @future_sediment_load_fields = 0

    @current_n_load_animals = 0
    @current_p_load_animals = 0
    @current_sediment_load_animals = 0

    @future_n_load_animals = 0
    @future_p_load_animals = 0
    @future_sediment_load_animals = 0

    @farm.fields.each do |field|
      if (!field.field_type.nil?) && (field.field_type.id == 1 || field.field_type.id == 2 || field.field_type.id == 3)
        begin
          if field.other_land_use_conversion_acres_future
            @current_totals = computeBmpCalculations(field)
            calculate_bmps_without_conversion(field)
            calculate_bmps(field)
            if @with_conversion[:sediment] > @without_conversion[:sediment]
              @current_totals[:new_total_sediment_future] = @without_conversion[:sediment]
            end
            if @with_conversion[:nitrogen] > @without_conversion[:nitrogen]
              @current_totals[:new_total_n_future] = @without_conversion[:nitrogen]
            end
            if @with_conversion[:phosphorus] > @without_conversion[:phosphorus]
              @current_totals[:new_total_p_future] = @without_conversion[:phosphorus]
            end
          else
            @current_totals = computeBmpCalculations(field)
          end
        rescue Exception => e
          flash[:error] = e.message
          @current_totals = {:new_total_n => 0, :new_total_p => 0, :new_total_sediment => 0, :new_total_n_future => 0, :new_total_p_future => 0, :new_total_sediment_future => 0}
        end

        @current_n_load_fields = @current_n_load_fields + @current_totals[:new_total_n]
        @current_p_load_fields = @current_p_load_fields + @current_totals[:new_total_p]
        @current_sediment_load_fields = @current_sediment_load_fields + @current_totals[:new_total_sediment]

        logger.debug "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @current_totals[:new_total_sediment] #{@current_totals[:new_total_sediment]}"
        @new_total_sediment = @current_totals[:new_total_sediment]


        @future_n_load_fields = @future_n_load_fields + @current_totals[:new_total_n_future]
        @future_p_load_fields = @future_p_load_fields + @current_totals[:new_total_p_future]
        @future_sediment_load_fields = @future_sediment_load_fields + @current_totals[:new_total_sediment_future]
        @new_total_sediment_future = @current_totals[:new_total_sediment_future]

        watershed_segment = WatershedSegment.where(:id => field.watershed_segment_id).first
        if (!watershed_segment.nil?)
          @baseline_sediment_load_fields += watershed_segment[:sediment_crop_baseline] * field.acres / 2000.0 if field.field_type_id == 1
          @baseline_sediment_load_fields += watershed_segment[:sediment_pasture_baseline] * field.acres / 2000.0 if field.field_type_id == 2
          @baseline_sediment_load_fields += watershed_segment[:sediment_hay_baseline] * field.acres / 2000.0 if field.field_type_id == 3


          if field.tmdl.nil?
            #@baseline_n_load_fields += watershed_segment[:n_crop_baseline] * field.acres if field.field_type_id == 1
            @baseline_n_load_fields += watershed_segment[:n_pasture_baseline] * field.acres if field.field_type_id == 2
            @baseline_n_load_fields += watershed_segment[:n_hay_baseline] * field.acres if field.field_type_id == 3

            @baseline_p_load_fields += watershed_segment[:p_crop_baseline] * field.acres if field.field_type_id == 1
            @baseline_p_load_fields += watershed_segment[:p_pasture_baseline] * field.acres if field.field_type_id == 2
            @baseline_p_load_fields += watershed_segment[:p_hay_baseline] * field.acres if field.field_type_id == 3

          else # use Maryland TMDL
            #@baseline_n_load_fields += field.tmdl[:total_n] * field.acres
            @baseline_p_load_fields += field.tmdl[:total_p] * field.acres
          end
        end
      end
      # animals
      if (!field.field_type.nil?) && (field.field_type.id == 4)
        @current_totals = computeLivestockBmpCalculations(field)
        @current_n_load_animals += @current_totals[:current_load_nitrogen]
        @current_p_load_animals += @current_totals[:current_load_phosphorus]
        @current_sediment_load_animals += @current_totals[:current_load_sediment]
        #future
        @future_totals = computeLivestockBmpCalculationsFuture(field)
        @future_n_load_animals += @future_totals[:current_load_nitrogen]
        @future_p_load_animals += @future_totals[:current_load_phosphorus]
        @future_sediment_load_animals += @future_totals[:current_load_sediment]
      end

      # @is_farm_meets_baseline = is_farm_meets_baseline(@farm)

    end
  end



  # GET/farms/id/submit
  def submit
    add_breadcrumb 'Projects', :farms_path
    add_breadcrumb @farm.name

    @fields = Naturalsorter::Sorter.sort_by_method(@farm.fields, :name, true)
    @arrWatersheds = Array.new
    @fields.each do |field|
      @arrWatersheds << field.watershed_name unless @arrWatersheds.include?(field.watershed_name)
      end

    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "Pre filled MDA CCR form #{@farm.name}.pdf",
               #html: render_to_string(:layout => false , :template => "farms/review.pdf.erb"),
               #:template => 'farms/review',
               :wkhtmltopdf => '/usr/bin/wkhtmltopdf-i386', # path to binary
               :disposition => 'attachment',
               :footer => {:center => 'NutrientNet',
                           :right => '[page] of [topage]'}
      end
    end
  end

  # GET /farms/new
  # GET /farms/new.json
  def new
    add_breadcrumb 'Projects', :farms_path
    add_breadcrumb 'New project'
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /farms/1/edit
  def edit
    add_breadcrumb 'Projects', :farms_path
    add_breadcrumb @farm.name

    @step = params[:step] || '1'
    add_breadcrumb 'Details' if @step == '1'
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
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /farms/1
  # PUT /farms/1.json
  def update
    # @farm = @farm.find(params[:id])
    @step = (params[:step] || 1).to_i
    #@next_step = (params[:step] || 1).to_i + 1

    respond_to do |format|
      if @farm.update_attributes(params[:farm])
        format.html { redirect_to edit_farm_path(@farm, :step => @step+1), notice: 'Farm was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /farms/1
  # DELETE /farms/1.json
  def destroy
    @farm.destroy

    respond_to do |format|
      format.html { redirect_to farms_url }
    end
  end

  # POST /farms/1/duplicate
  def duplicate
    @farm_dup = @farm.amoeba_dup
    # @farm_dup.name << ' (duplicated)'

    @is_duplicate = true

    #Farm.skip_callback(:create)
    #Field.skip_callback(:create)
    #Soil.skip_callback(:create)

    #Farm.skip_callback(:update)
    #Field.skip_callback(:update)
    #Soil.skip_callback(:update)

    #Farm.skip_callback(:save)
    #Field.skip_callback(:save)
    #Soil.skip_callback(:save)

    #Farm.send(:create_without_callbacks)
    #@farm_dup.save(:validate => false)


    respond_to do |format|
      if @farm_dup.save!(:validate => false) # TODO: remove !
                                             #Farm.set_callback(:create)
                                             #Field.set_callback(:create)
                                             #Soil.set_callback(:create)
                                             #Farm.set_callback(:update)
                                             #Field.set_callback(:update)
                                             #Soil.set_callback(:update)
                                             #Farm.set_callback(:save)
                                             #Field.set_callback(:save)
                                             #Soil.set_callback(:save)
        format.html { redirect_to farms_url, notice: 'Farm was successfully duplicated.' }
      else
        #Farm.set_callback(:create)
        format.html { redirect_to farms_url, notice: 'Could not duplicate farm.' }
      end
    end

  end

  def send_to_mapping_site
    render :send_to_mapping_site, :layout => false
  end

  # Note that this method is not protected by Cancan
  def receive_from_mapping_site
    logger.debug "$$$$$$$$$$$$$$$$$ START METHOD"
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
        @field.is_acres_from_map = true

        @field.segment_id = params["field#{i}segment"]

        # @field.tmdl = Tmdl.where(:code => params["field#{i}huc12"].to_i).first
        @field.tmdl = Tmdl.where(:code => params["field#{i}tmdl_md"]).first
        @field.tmdl_va = params["field#{i}tmdl_va"]

        @field.watershed_name = params["field#{i}huc12name"]

        # (params.has_key?("field#{i}tmdl") || Tmdl.where(:code => params["field#{i}tmdl"].to_i).first == nil) ? false : true
        #@field.tmdl_watershed = (params["field#{i}tmdl"] != 'none')

        # get the watershed segment
        watershed_segment = WatershedSegment.where(:key => @field.segment_id).first

        if !watershed_segment.nil?
          @field.watershed_segment_id = watershed_segment.id
        end

        # get the top 3 soils (if any)
        @listSoils = Array.new
        if params.has_key?("field#{i}pctsoiltype")
          arrFieldpctsoiltype = params["field#{i}pctsoiltype"].split("|")
          arrFieldmukey = params["field#{i}mukey"].split("|")
          arrFieldniccdcdpct = params["field#{i}niccdcdpct"].split("|")
          arrFieldmuname = params["field#{i}muname"].split("|")
          arrFieldhydgrp = params["field#{i}hydgrpdcd"].split("|")
          arrFieldmusym = params["field#{i}musym"].split("|")

          arrFieldpctsoiltype.each_with_index do |fieldpctsoiltype, index|
            if !arrFieldmuname[index].eql?('Water') then # ignore soil if water
              @listSoils << {
                  :percent => arrFieldpctsoiltype[index],
                  :mukey => arrFieldmukey[index],
                  :niccdcdpct => arrFieldniccdcdpct[index],
                  :muname => arrFieldmuname[index],
                  :hydgrpdcd => arrFieldhydgrp[index],
                  :musym => arrFieldmusym[index]
              }
            end
          end
        end

        # sort by percentage in descending order
        @listSoils = @listSoils.sort_by! { |e| e[:percent] }.reverse!

        # at most 3 soils are displayed
        @nbSoils = [3, @listSoils.length].min

        @field.soils.destroy_all

        @nbSoils.times do
          @field.soils.build
        end

        @soil_total = 0

        (0..@nbSoils-1).each do |i|
          @field.soils[i].percent = @listSoils[i][:percent]
          @soil_total += @listSoils[i][:percent].to_f
          @field.soils[i].map_unit_key = @listSoils[i][:mukey]
          @field.soils[i].niccdcdpct = @listSoils[i][:niccdcdpct]
          @field.soils[i].map_unit_name = @listSoils[i][:muname]
          @field.soils[i].hydrologic_group = @listSoils[i][:hydgrpdcd]
          @field.soils[i].map_unit_symbol = @listSoils[i][:musym]

          # getSoilData(1726303, 'Meadowville', 'B') #
          data = getSoilData(@field.soils[i].map_unit_key, @field.soils[i].map_unit_symbol, @field.soils[i].hydrologic_group)

          if data
            @field.soils[i].component_name = data[:component_name]
            @field.soils[i].percent_clay = data[:percent_clay]
            @field.soils[i].percent_sand = data[:percent_sand]
            @field.soils[i].percent_silt = data[:percent_silt]
            @field.soils[i].bulk_density = data[:bulc_density]
            @field.soils[i].organic_carbon = data[:organic_carbon]
            @field.soils[i].slope = data[:slope]
          else
            @field.soils[i].component_name = ''
            @field.soils[i].percent_clay = 0
            @field.soils[i].percent_sand = 0
            @field.soils[i].percent_silt = 0
            @field.soils[i].bulk_density = 0
            @field.soils[i].organic_carbon = 0
            @field.soils[i].slope = 0
          end

          # TODO: how to display errors?

        end 

        logger.debug "@@@@@@@@@@@@@@@@@@@ SOIL TOTAL: #{@soil_total}"
        @field.soils.each do |soil|
          logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$ soil percent #{soil.percent}"
          soil.percent = (soil.percent)/(@soil_total)
          logger.debug "****************************** NEW soil percent #{soil.percent}"
          soil.save
        end



        # there should be at least one strip
        @field.strips.build if @field.strips.empty?
        is_future_strip_found =false
        @field.strips.each do |strip|
          is_future_strip_found = true if strip.is_future
        end

        if !is_future_strip_found
          @field.strips.build(:is_future => true)
        end

        #if watershed_segment.nil?
        #  render 'errors/map_down', :layout => false
        #else
          @field.save(:validate => false)
        #end
      end

      if !watershed_segment.nil?

        @farm.coordinates = params[:parcelcoords]
        @farm.acres = params[:parcelacres]
        @farm.save
        #######################

      
        render :receive_from_mapping_site, :layout => false
      end


    elsif
      # Something's not right. Assume security breach (CSRF).
    sign_out :user
      render 'errors/not_authorized', :layout => false
    end
  end

# Web service call
  def getSoilData(map_unit_key, map_unit_symbol, hydrologic_group)


    #sql = "SELECT TOP 1 chorizon.sandtotal_r as percent_sand, chorizon.silttotal_r as percent_silt, chorizon.claytotal_r as percent_clay, round((chorizon.om_r) / 1.72, 2) as organic_carbon, chorizon.dbthirdbar_r as bulc_density, component.hydgrp as hydrologic_group, component.slope_r as slope, component.compname as component_name, component.mukey as map_unit_key, mapunit.musym as map_unit_symbol, mapunit.muname as map_unit_name FROM mapunit, component, chorizon WHERE mapunit.mukey = component.mukey AND component.cokey = chorizon.cokey AND component.majcompflag = 'yes' AND mapunit.mukey = #{map_unit_key} AND component.hydgrp = '#{hydrologic_group}' AND component.compname = '#{component_name}' ORDER BY chorizon.hzdepb_r"
    #sql = "SELECT TOP 1 chorizon.sandtotal_r as percent_sand, chorizon.silttotal_r as percent_silt, chorizon.claytotal_r as percent_clay, round((chorizon.om_r) / 1.72, 2) as organic_carbon, chorizon.dbthirdbar_r as bulc_density, component.hydgrpdcd as hydrologic_group, component.slope_r as slope, component.niccdcdpct as niccdcdpct, component.mukey as map_unit_key, mapunit.musym as map_unit_symbol, mapunit.muname as map_unit_name FROM mapunit, component, chorizon WHERE mapunit.mukey = component.mukey AND component.cokey = chorizon.cokey AND component.majcompflag = 'yes' AND mapunit.mukey = #{map_unit_key} AND component.hydgrpdcd = '#{hydrologic_group}' AND component.niccdcdpct = '#{niccdcdpct}' ORDER BY chorizon.hzdepb_r"
    #sql = "SELECT TOP 1 chorizon.sandtotal_r as percent_sand, chorizon.silttotal_r as percent_silt, chorizon.claytotal_r as percent_clay, round((chorizon.om_r) / 1.72, 2) as organic_carbon, chorizon.dbthirdbar_r as bulc_density, component.hydgrp as hydrologic_group, component.slope_r as slope, component.comppct_r as component, component.compname as component_name, component.mukey as map_unit_key, mapunit.musym as map_unit_symbol, mapunit.muname as map_unit_name FROM mapunit, component, chorizon WHERE mapunit.mukey = component.mukey AND component.cokey = chorizon.cokey AND component.majcompflag = 'yes' AND mapunit.mukey = #{map_unit_key} AND component.comppct_r  = #{niccdcdpct} ORDER BY chorizon.hzdepb_r"
    sql = "SELECT top 1 chorizon.sandtotal_r as percent_sand, chorizon.silttotal_r as percent_silt, chorizon.claytotal_r as percent_clay, round((chorizon.om_r) / 1.72, 2) as organic_carbon, chorizon.dbthirdbar_r as bulc_density, component.hydgrp as hydrologic_group, component.slope_r as slope, component.comppct_r as component, component.compname as component_name, component.mukey as map_unit_key, mapunit.musym as map_unit_symbol, mapunit.muname as map_unit_name FROM mapunit, component, chorizon WHERE mapunit.mukey = component.mukey AND component.cokey = chorizon.cokey AND component.majcompflag = 'yes' AND mapunit.mukey = #{map_unit_key} AND component.hydgrp='#{hydrologic_group}' AND mapunit.musym='#{map_unit_symbol}' ORDER BY chorizon.hzdepb_r"

    # client = Savon.client(wsdl: "http://sdmdataaccess.nrcs.usda.gov/Tabular/SDMTabularService.asmx?WSDL")
    client = Savon.client(wsdl: Rails.root.to_s + "/config/wsdl/soils_database.xml")
    logger.debug "*********************** client: #{client}"

    begin
      response = client.call(:run_query, message: {"Query" => sql})
      if response.success?
        return response.to_array(:run_query_response, :run_query_result, :diffgram, :new_data_set, :table).first
      end
    rescue # the SOAP call failed
      return nil
    end
  end


  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end