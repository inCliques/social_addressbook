configatron.viadeo.configure_from_hash({
  :token_url     => 'https://secure.viadeo.com/oauth-provider/access_token2',
  :authorize_url => 'https://secure.viadeo.com/oauth-provider/authorize2',
  :api_base      => 'https://api.viadeo.com'
})

configatron.twitter.configure_from_hash({
  :request_token_url => 'https://api.twitter.com/oauth/request_token',
  :authorize_url     => 'https://api.twitter.com/oauth/authorize',
  :access_token_url  => 'https://api.twitter.com/oauth/access_token'
})

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, configatron.twitter.client_key, configatron.twitter.client_secret
  provider :viadeo, configatron.viadeo.client_key, configatron.viadeo.client_secret
	{:client_options => {:ssl => {:ca_path => "/System/Library/OpenSSL/certs"}}}  # Modify this with your SSL certificates path
end
