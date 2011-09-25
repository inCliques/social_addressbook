class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/invite
  # GET /groups/invite.xml
  def invite
    @group = Group.find(params[:id])
    @offline_user = OfflineUser.new

    respond_to do |format|
      format.html # invite.html.erb
      format.xml  { render :xml => @offline_user }
    end
  end

  # POST /groups/1/invite_save
  def invite_save
    @group = Group.find(params[:id])
    @offline_user = OfflineUser.new(params[:offline_user])

    respond_to do |format|
      if @offline_user.save
        @groups_offline_user = GroupsOfflineUser.new()
        @groups_offline_user.offline_user = @offline_user
        @groups_offline_user.group = @group 
        @groups_offline_user.save
        format.html { redirect_to(invite_group_path(@group), :notice => 'Invitation was send.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "invite" }
        format.xml  { render :xml => @groups_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /groups/join
  # GET /groups/join.xml
  def join
    @groups_user = GroupsUser.new

    respond_to do |format|
      format.html # join.html.erb
      format.xml  { render :xml => @groups_user }
    end
  end

  # POST /groups/1/join_save
  def join_save
    @group = Group.find(params[:id])
    @groups_user = GroupsUser.new(params[:group])
    @groups_user.user = current_user
    @groups_user.group = @group 

    @groups_user.user = current_user
    @groups_user.group = @group

    respond_to do |format|
      if @groups_user.save
        format.html { redirect_to(@group, :notice => 'You joined the group.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "join" }
        format.xml  { render :xml => @groups_user.errors, :status => :unprocessable_entity }
      end
    end
  end


  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @group.owner = current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(groups_url, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end
