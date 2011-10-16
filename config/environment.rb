# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SocialAddressbook::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
   :address => "mail.currentdomain.co.uk",
   :authentication => :login,
   :port => 26,
   :domain => "incliqu.es",
   :authentication => :login,
   :user_name => "test@currentdomain.co.uk",
   :password => "12345"
}
