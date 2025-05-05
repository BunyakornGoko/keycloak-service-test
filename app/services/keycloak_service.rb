require 'net/http'
require 'uri'
require 'json'

class KeycloakService
  def self.keycloak_base_url
    url = ENV['KEYCLOAK_URL'].to_s.strip
    
    # Remove protocol if included
    url = url.sub(/^https?:\/\//, '')
    
    # Ensure no trailing slash
    url = url.sub(/\/$/, '')
    
    "https://#{url}"
  end

  def self.test_connection
    begin
      uri = URI.parse("#{keycloak_base_url}/realms/#{ENV['REALM_ID']}")
      request = Net::HTTP::Get.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', open_timeout: 5) do |http|
        http.request(request)
      end

      {
        status: response.code.to_i,
        message: response.message,
        success: response.is_a?(Net::HTTPSuccess),
        url: uri.to_s
      }
    rescue => e
      {
        status: nil,
        message: e.message,
        success: false,
        url: "#{keycloak_base_url}/realms/#{ENV['REALM_ID']}",
        error: e.class.name
      }
    end
  end

  def self.get_token(code)
    uri = URI.parse("#{keycloak_base_url}/realms/#{ENV['REALM_ID']}/protocol/openid-connect/token")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      "grant_type" => "authorization_code",
      "code" => code,
      "client_id" => ENV['CLIENT_ID'],
      "client_secret" => ENV['CLIENT_SECRET'],
      "redirect_uri" => ENV['REDIRECT_URI']
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    return nil unless response.is_a?(Net::HTTPSuccess)
    
    begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      nil
    end
  end

  def self.get_user_info(access_token)
    uri = URI.parse("#{keycloak_base_url}/realms/#{ENV['REALM_ID']}/protocol/openid-connect/userinfo")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    return nil unless response.is_a?(Net::HTTPSuccess)
    
    begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      nil
    end
  end

  def self.refresh_token(refresh_token)
    uri = URI.parse("#{keycloak_base_url}/realms/#{ENV['REALM_ID']}/protocol/openid-connect/token")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      "grant_type" => "refresh_token",
      "refresh_token" => refresh_token,
      "client_id" => ENV['CLIENT_ID'],
      "client_secret" => ENV['CLIENT_SECRET']
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    return nil unless response.is_a?(Net::HTTPSuccess)
    
    begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      nil
    end
  end

  def self.keycloak_logout(refresh_token)
    return if refresh_token.nil?
    
    uri = URI.parse("#{keycloak_base_url}/realms/#{ENV['REALM_ID']}/protocol/openid-connect/logout")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      "client_id" => ENV['CLIENT_ID'],
      "client_secret" => ENV['CLIENT_SECRET'],
      "refresh_token" => refresh_token
    )

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  rescue => e
    Rails.logger.error("Error during logout: #{e.message}")
  end
end 