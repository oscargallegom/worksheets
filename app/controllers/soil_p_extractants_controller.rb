class SoilPExtractantsController < ApplicationController

  load_and_authorize_resource :soil_test_laboratory
  load_and_authorize_resource :through => :soil_test_laboratory

  # GET /soil_test_laboratory
  # GET /soil_test_laboratory.soil_p_extractant.json
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soil_p_extractants, :only => [:id, :name, :unit] }
      #format.js
    end
  end
end
