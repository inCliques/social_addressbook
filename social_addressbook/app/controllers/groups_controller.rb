class GroupsController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource

  # GET /groups
  # GET /groups.xml
  def index
    @groups = current_user.groups.where("private IS NOT 0 AND owner_id IS NOT ?", current_user.id)
    @my_groups = current_user.groups.where(:owner_id => current_user.id)


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
    @offline_user_datum = OfflineUserDatum.new

    respond_to do |format|
      format.html # invite.html.erb
      format.xml  { render :xml => @offline_user }
    end
  end

  # POST /groups/1/invite_save
  def invite_save
    @group = Group.find(params[:id])

    # Check if the invited user is already registered in the system
    if UserDatum.where(:value => params[:user_datum][:value], :data_type_id => params[:user_datum][:data_type_id]).count > 0

      # In this case we add the associated person to the clique
      @user_datum = UserDatum.where(:value => params[:user_datum][:value], :data_type_id => params[:user_datum][:data_type_id]).first
      @invitee = @user_datum.user
      GroupsUser.create(:user => @invitee, :group => @group)

      # We also want to notify the user that he was added to the clique
      if @invitee.has_datum_of_type('Email')
        InviteMailer.send_invitation(current_user, @invitee, @group).deliver  
      end

    else

      # Otherwise, we create an offline account for this user 
      @invitee = OfflineUser.create(:name => params[:user_datum][:name]) # This is a hack to avoid multiple forms on one page: use the name parameter for a second UserDatum of type name
      # Add the personal information to this user
      @user_datum = OfflineUserDatum.new(params[:user_datum])
      @user_datum.data_type_id = params[:user_datum][:data_type_id]
      @user_datum.offline_user_id = @invitee.id
      @user_datum.save

      # And add him to the clique
      GroupsOfflineUser.create(:offline_user => @invitee, :group => @group)

      # In case an email was provided, we also send an email invitation to join incliques
      if @user_datum.data_type.name == 'Email'
        InviteMailer.send_invitation(current_user, @invitee, @group).deliver  
      end

    end

    respond_to do |format|
      if @user_datum.errors.length.zero?
        format.html { redirect_to(invite_group_path(@group), :notice => 'Person succesfully invited.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "invite" }
        format.xml  { render :xml => @user_datum.errors, :status => :unprocessable_entity }
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
    
        format.html { redirect_to(invite_group_path(@group)) }
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
        format.html { redirect_to(groups_url) }
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
