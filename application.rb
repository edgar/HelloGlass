ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

class Application < Sinatra::Base
  enable :sessions

  def session_info
    {
      access_token: session[:access_token],
      refresh_token: session[:refresh_token],
      expires_in: session[:expires_in],
      issued_at: session[:issued_at]
    }
  end

  def session_info!(auth)
    session[:access_token] = auth.access_token
    session[:refresh_token] = auth.refresh_token
    session[:expires_in] = auth.expires_in
    session[:issued_at] = auth.issued_at
  end

  before do
    options = {
      application_name: 'Hello Glass',
      application_version: 'v0.1'
    }
    @client                              = Google::APIClient.new(options)
    @client.authorization.client_id      = ENV['GLASS_CLIENT_ID']
    @client.authorization.client_secret  = ENV['GLASS_CLIENT_SECRET']
    @client.authorization.scope          = [
      "https://www.googleapis.com/auth/glass.timeline",
      "https://www.googleapis.com/auth/userinfo.profile"
    ]
    @client.authorization.redirect_uri = to('/oauth2callback')
    @client.authorization.code = params[:code] if params[:code]
    @mirror = @client.discovered_api('mirror', 'v1')
    @oauth2 = @client.discovered_api('oauth2', 'v2')

    @client.authorization.update_token!(session_info) if session[:access_token]
    if @client.authorization.refresh_token && @client.authorization.expired?
      @client.authorization.fetch_access_token!
      session_info!(@client.authorization)
    end
    unless @client.authorization.access_token || request.path_info =~ /^\/oauth2/
      redirect to("/oauth2authorize")
    end
  end

  get '/oauth2authorize' do
    redirect @client.authorization.authorization_uri.to_s, 303
  end

  get '/oauth2callback' do
    @client.authorization.fetch_access_token!
    session_info!(@client.authorization)
    redirect to('/')
  end

  get '/' do
    # Insert a card in timeline
    method = @mirror.timeline.insert
    @client.execute!(
      api_method: method,
      body_object: method.request_schema.new({ text: 'Hello Glass' }),
      media: nil,
      parameters: nil
    ).data

    # Display a text for the browser
    result = @client.execute(api_method: @oauth2.userinfo.get)
    locals = { username: result.data.name }
    haml(:index, locals: locals)
  end
end