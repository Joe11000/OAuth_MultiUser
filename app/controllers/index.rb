get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  debugger
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
  user = User.find_by_oauth_token(params[:oauth_token])
  if not user
    User.create(oauth_token: params[:oauth_token] , oauth_verifier:  params[:oauth_verifier])
  end

  @access_token = {token: user.oauth_token, secret: oauth_verifier}
  
  redirect to '/'
end
