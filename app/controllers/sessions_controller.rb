class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:lobby, :callback, :debug_keycloak]
  
  def keycloak_url
    @keycloak_url
  end

  def lobby
    if Rails.env.test?
      bypass_keycloak_authentication
    else
      setup_keycloak_auth_url
    end
    render 'lobby'
  end

  def callback
    code = params[:code]
    if code.present?
      process_keycloak_code(code)
    else
      flash[:alert] = "Authentication failed. Please try again."
      redirect_to lobby_path
    end
  end

  def logout
    refresh_token = session[:refresh_token]
    clear_session
    KeycloakService.keycloak_logout(refresh_token)
    redirect_to lobby_path, notice: "You have been successfully logged out."
  end

  # Debug route to test Keycloak connection
  # Only use in development environment
  def debug_keycloak
    return head :forbidden unless Rails.env.development?
    
    @connection_test = KeycloakService.test_connection
    @env_vars = {
      keycloak_url: ENV['KEYCLOAK_URL'],
      realm_id: ENV['REALM_ID'],
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'] ? "[PRESENT]" : "[MISSING]",
      redirect_uri: ENV['REDIRECT_URI']
    }
    
    render 'debug_keycloak'
  end

  private

  def bypass_keycloak_authentication
    @keycloak_url = "/"
    session[:user_email] = "test@example.com"
    session[:user_id] = "test_user_id"
    session[:refresh_token] = "test_refresh_token"
  end

  def setup_keycloak_auth_url
    # @keycloak_url = "#{KeycloakService.keycloak_base_url}/realms/#{ENV['REALM_ID']}/protocol/openid-connect/auth?client_id=#{ENV['CLIENT_ID']}&redirect_uri=#{ENV['REDIRECT_URI']}&response_type=code&scope=openid"
    @keycloak_url = "https://sso.odd.works/realms/BMA-Training/protocol/openid-connect/auth?client_id=1&redirect_uri=http://localhost:3000/auth/callback&response_type=code&scope=openid"
  end

  def process_keycloak_code(code)
    token = KeycloakService.get_token(code)
    
    if token.nil?
      handle_failed_authentication("Failed to get token from Keycloak.")
      return
    end

    userinfo = KeycloakService.get_user_info(token["access_token"])
    
    if userinfo.nil?
      handle_failed_authentication("Failed to get user information from Keycloak.")
      return
    end

    store_user_session(userinfo, token["refresh_token"])
    redirect_to root_path, notice: "Successfully logged in."
  end

  def handle_failed_authentication(message)
    clear_session
    flash[:alert] = message
    redirect_to lobby_path
  end

  def store_user_session(userinfo, refresh_token)
    session[:user_email] = userinfo["email"]
    session[:user_id] = userinfo["sub"]
    session[:user_name] = userinfo["name"] || userinfo["preferred_username"]
    session[:refresh_token] = refresh_token
  end

  def clear_session
    session[:refresh_token] = nil
    session[:user_email] = nil
    session[:user_id] = nil
    session[:user_name] = nil
  end
end 