class ApplicationController < ActionController::Base
  protect_from_forgery

  #   You can change the "bob" values the first
  #   one is the key and the second is the secret

  @@consumer=OAuth::Consumer.new("bob", "bob", {
      :site => "http://localhost:8080/nuxeo",
      :request_token_path => "/oauth/request-token",
      :access_token_path => "/oauth/access-token",
      :http_method => :get,
      :oauth_version => "1",
      :oauth_callback => "http://localhost:3000/user/callback"
  })

end
