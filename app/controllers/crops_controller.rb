class CropsController < ApplicationController
load_and_authorize_resource :crop_category
  load_and_authorize_resource :through => :crop_category

  # GET /crop_categories/1/crops/1.json
  def index
    respond_to do |format|
      format.json { render json: @crops }
    end
  end

end
