class CountiesController < ApplicationController

  load_and_authorize_resource :state
  load_and_authorize_resource :through => :state

  # GET /cities
  # GET /cities.json
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @counties, :only => [:id, :name] }
      format.js
    end
  end

  # GET /cities/1
  # GET /cities/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @county }
      format.js
    end
  end

  # GET /cities/new
  # GET /cities/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @county }
    end
  end

  # GET /cities/1/edit
  def edit
    @county = County.find(params[:id])
  end

  # POST /cities
  # POST /cities.json
  def create

    respond_to do |format|
      if @county.save
        format.html { redirect_to @county, notice: 'City was successfully created.' }
        format.json { render json: @county, status: :created, location: @county }
      else
        format.html { render action: "new" }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.json
  def update

    respond_to do |format|
      if @county.update_attributes(params[:county])
        format.html { redirect_to @county, notice: 'City was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy

    @county.destroy

    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end
  end
end
