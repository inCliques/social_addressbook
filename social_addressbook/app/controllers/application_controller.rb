require 'net/http'
require 'uri'

class ApplicationController < ActionController::Base 
  layout :determine_layout

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

  private
  def determine_layout
    current_user ? "private" : "public"
  end

end
