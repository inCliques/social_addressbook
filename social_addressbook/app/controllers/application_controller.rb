class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to(root_url, :notice => exception.message)
  end

  # Send users to the edit user data when login in the first time
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) && resource_or_scope.sign_in_count<=1
      user_data_path 
    else
      super
    end
  end
end
