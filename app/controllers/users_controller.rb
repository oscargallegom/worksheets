class UsersController < ApplicationController


  # if params[:user][:password].blank?
  #  params[:user].delete(:password)
  #  params[:user].delete(:password_confirmation)
  # end


  # GET /users
  # GET /users.json
  def index
    @users = User.searchByStatus(params[:status])

        # User.search(params[:search]).disabled

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

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
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
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
    @user = User.find(params[:id])
    @user.soft_delete

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # PUT /users/disable_multiple
  def disable_multiple
    @users = User.find(params[:user_ids_all])
    @users.each do |user|
      if (params[:user_ids] && params[:user_ids].include?(user.id.to_s)) then
        #user.update_attributes!(:deleted_at => Time.now)
        user.update_attributes!(:approved => true)
      else
        user.update_attributes!(:approved => false)
      end
    end
    flash[:notice] = "Updated users!"
    redirect_to users_path
  end
end
