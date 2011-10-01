class ViadeoConnectController < ApplicationController
  def step1
    initialize_vars
    url = "#{@oauth_vars[:authorize_url]}?client_id=#{@oauth_vars[:client_id]}&response_type=code&redirect_uri=#{@redirect_uri}"
    redirect_to url
  end

  # this method will be called back with a code parameter
  def step2
    initialize_vars
    url = "#{@oauth_vars[:token_url]}?code=#{params[:code]}&grant_type=authorization_code&client_id=#{@oauth_vars[:client_id]}&client_secret=#{@oauth_vars[:client_secret]}&response_type=code&redirect_uri=#{@redirect_uri}"
    rep = JSON.parse(get_json_from_https(url))
    session[:access_token] = rep["access_token"]

    do_API_call
  end

  def do_API_call
    # call on /me
    me_url = "#{@oauth_vars[:api_base]}/me?access_token=#{session[:access_token]}"
    puts "url = #{me_url}"
    json_result = JSON.parse(get_json_from_https(me_url))
    #render :text => "Hello world, #{json_result['first_name']} #{json_result['last_name']} !"
    redirect_to :controller => :user_data, :action => :new, :type => "Viadeo", :value => json_result['link']
  end

end