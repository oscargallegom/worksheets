class CountiesController < ApplicationController

  load_and_authorize_resource :state
  load_and_authorize_resource :through => :state

  # GET /counties
  # GET /counties.json
  def index

    respond_to do |format|
      #format.html # index.html.erb
      format.json { render json: @counties, :only => [:id, :name] }
      #format.js
    end
  end
end
