class SoilPExtractantsController < ApplicationController

  load_and_authorize_resource

  # GET /soil_p_extractants/1.json
  def show
    respond_to do |format|
      format.json { render json: @soil_p_extractant, :only => [:id, :name, :unit] }
    end
  end

end
