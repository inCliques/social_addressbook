class GroupsController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource

  # GET /groups
  # GET /groups.xml
  def index
    @groups = current_user.groups

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
    error = false

    # Check if the invited user is already in the system
    if User.where(:email => params[:offline_user][:email]).count  == 0
      @offline_user = OfflineUser.new(params[:offline_user])
      error = error or @offline_user.save

      if (not error)
        GroupsOfflineUser.create(:offline_user => @offline_user, :group => @group)
      end
    else
      GroupsUser.create(:user => User.where(:email => params[:offline_user][:email]).first, :group => @group)
    end

    # Sending email invitation
    InviteMailer.send_invitation(current_user, @group, params[:offline_user][:email]).deliver  

    respond_to do |format|
      if not error 
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
        # We make the owner part of the group
        GroupsUser.create(:user => current_user, :group => @group)
    
        format.html { redirect_to(invite_group_path(@group), :notice => 'Group was successfully created.') }
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
