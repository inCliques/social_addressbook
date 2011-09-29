class UserDataController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource

  # GET /user_data
  # GET /user_data.xml
  def index
    @user_data = UserDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_data }
    end
  end

  # GET /user_data/1
  # GET /user_data/1.xml
  def show
    @user_datum = UserDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_datum }
    end
  end

  # GET /user_data/new
  # GET /user_data/new.xml
  def new
    @user_datum = UserDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_datum }
    end
  end

  # GET /user_data/1/edit
  def edit
    @user_datum = UserDatum.find(params[:id])
  end

  # POST /user_data
  # POST /user_data.xml
  def create
    @user_datum = UserDatum.new(params[:user_datum])

    respond_to do |format|
      if @user_datum.save
        format.html { redirect_to(@user_datum, :notice => 'User datum was successfully created.') }
        format.xml  { render :xml => @user_datum, :status => :created, :location => @user_datum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_datum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_data/1
  # PUT /user_data/1.xml
  def update
    @user_datum = UserDatum.find(params[:id])

    respond_to do |format|
      if @user_datum.update_attributes(params[:user_datum])
        format.html { redirect_to(@user_datum, :notice => 'User datum was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_datum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_data/1
  # DELETE /user_data/1.xml
  def destroy
    @user_datum = UserDatum.find(params[:id])
    @user_datum.destroy

    respond_to do |format|
      format.html { redirect_to(user_data_url) }
      format.xml  { head :ok }
    end
  end
end
