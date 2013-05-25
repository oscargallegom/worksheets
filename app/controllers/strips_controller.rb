class StripsController < ApplicationController
  load_and_authorize_resource :farm
  load_and_authorize_resource :field, :through => :farm
  load_and_authorize_resource :strip, :through => :field

  # GET /crop_categories/1/crops/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

end
