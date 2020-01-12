# frozen_string_literal: true

module Googles
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
  CREDENTIALS_PATH = 'app/config/googles/credentials.json'
  TOKEN_PATH = 'app/config/googles/token.yaml'
  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze

  module_function

  def get_authorizer
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = 'default'
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts 'Open the following URL in the browser and enter the ' \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end
end
