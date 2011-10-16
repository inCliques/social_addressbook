class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    print omniauth.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    # Already authenticated
    if authentication
      flash[:notice] = "Already connected to #{omniauth['provider']}. To connect with a different account, please sign out of #{omniauth['provider']}."
      # FIXME: This will only redirect, but not sign the user in
      redirect_to user_data_url
      #sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      authentication = current_user.authentications.new(:provider => omniauth['provider'], :uid => omniauth['uid'])
      authentication.token = omniauth['credentials']['token'] or ''
      authentication.secret = omniauth['credentials']['secret'] or ''
      authentication.save!
      # Create a new user datum for the provider
      #UserDatum.create!(:user_id => current_user, :data_type_id => DataType.find_by_name(omniauth['provider']), :value => omniauth['uid'])
      # Import viadeo contact cards
      if omniauth['provider'] == 'viadeo'
        print "Import viadeo contact cards"
        import_viadeo_contact_card(omniauth)
      end
      flash[:notice] = "Successfully connected to #{omniauth['provider']}."
      # FIXME: This should redirect to the import dialog for the provider
      redirect_to user_data_url
    # FIXME: We don't currently allow users to sign up via OAuth, so won't hit this case
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in sucessfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  #def query(uid)
    #authentication = Authentication.find_by_user_id_and_uid(current_user.id, uid)
    #if authentication.provider == 'twitter'
      ## Query twitter
      #UserDatum.create!(:user_id => current_user, :data_type_id => :value => )
    #elsif authentication.provider == 'viadeo'
      ## Query viadeo
    #end
  #end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    redirect_to user_data_url, :notice => "Successfully destroyed authentication."
  end

  # FIXME this doesn't belong here
  def import_viadeo_contact_card(omniauth)
    url = "#{configatron.viadeo.api_base}/#{omniauth['uid']}/contact_cards?access_token=#{omniauth['credentials']['token']}"
    rep = JSON.parse(get_json_from_https(url))
    print rep.to_yaml
    rep['data'].each do |item|
      # import address
      #UserDatum.create(:user => current_user, :data_type => DataType.first( :conditions => { :name => 'Email' } ), :name => 'Viadeo', :value => email, :verified => false)
      @user_datum = UserDatum.new
      @user_datum.data_type_id = DataType.first( :conditions => { :name => 'Address' } ).id
      @user_datum.name = item['kind']
      @user_datum.user = current_user
      @user_datum.value = "#{item['company_address']} #{item['city']} #{item['postcode']}"
      @user_datum.verified = false
      @user_datum.save
      # import emails
      if !item['emails'].nil?
        item['emails'].each do |email|
          #UserDatum.create(:user => current_user, :data_type => DataType.first( :conditions => { :name => 'Email' } ), :name => 'Viadeo', :value => email, :verified => false)
          @user_datum = UserDatum.new
          @user_datum.data_type_id = DataType.first( :conditions => { :name => 'Email' } ).id
          @user_datum.name = item['kind']
          @user_datum.user = current_user
          @user_datum.value = email
          @user_datum.verified = false
          @user_datum.save
        end
      end
      # import phones
      if !item['phones'].nil?
        item['phones'].each do |phone|
          #UserDatum.create(:user => current_user, :data_type => DataType.first( :conditions => { :name => 'Email' } ), :name => 'Viadeo', :value => email, :verified => false)
          @user_datum = UserDatum.new
          @user_datum.data_type_id = DataType.first( :conditions => { :name => 'Phone' } ).id
          @user_datum.name = phone['type']
          @user_datum.user = current_user
          @user_datum.value = "#{phone['dialing']} #{phone['number']}"
          @user_datum.verified = false
          @user_datum.save
        end
      end
    end    
  end

  def get_json_from_https(url)  
    uri = URI.parse(url)  
    connection = Net::HTTP.new(uri.host, 443)  
    connection.use_ssl = true  
    connection.verify_mode = OpenSSL::SSL::VERIFY_NONE  
  
    resp = connection.request_get(uri.path + '?' + uri.query)  
  
    if resp.code != '200'  
       raise "web service error"  
    end  
  
     return resp.body  
  end

end
