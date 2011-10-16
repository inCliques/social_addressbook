class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    # Already authenticated
    if authentication
      flash[:notice] = "Already connected to #{omniauth['provider']}. To connect with a different account, please sign out of #{omniauth['provider']}."
      # FIXME: This will only redirect, but not sign the user in
      redirect_to user_data_url
      #sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Successfully connected to #{omniauth['provider']}."
      # FIXME: This should redirect to the import dialog for the provider
      redirect_to user_data_url
    # FIXME: We currently don't hit this case
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

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    redirect_to user_data_url, :notice => "Successfully destroyed authentication."
  end

end
