class UsersController < ApplicationController
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  add_breadcrumb 'Home', :farms_path
  add_breadcrumb 'User accounts', :users_path

  # GET /users
  # GET /users.json
  def index
    params[:tab] ||= 'all' # default tab

    @users = @users.searchByStatus(params[:tab]).search(params[:search]).page(params[:page]).order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    add_breadcrumb 'View'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
   def new
  #  @roles = Role.all
  #  add_breadcrumb 'New'
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @user }
  #  end
   end

  # GET /users/1/edit
  def edit
    add_breadcrumb 'Edit'
  end

  # POST /users
  # POST /users.json
   def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    params[:user][:role_ids] ||= []
    respond_to do |format|
      if @user.update_attributes(params[:user], :as => :admin)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.soft_delete

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # PUT /users/disable_multiple
  # def disable_multiple
  #   params[:user_ids_all] ||= []
  #   @users = User.find(params[:user_ids_all])
  #   @users.each do |user|
  #     if (params[:user_ids] && params[:user_ids].include?(user.id.to_s)) then
  #       #user.update_attributes!(:deleted_at => Time.now)
  #      user.update_attributes!(:approved => true)
  #     else
  #       user.update_attributes!(:approved => false)
  #     end
  #   end
  #   flash[:notice] = "Updated users!"
  #   redirect_to users_path(:tab => params[:tab])
  # end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
