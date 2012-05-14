#authorization of personal context to one application instance
#embeddable
require 'personal_context_authorization_scope.rb'
require 'shared_data_application.rb'
require 'account.rb'



#may be deleted if state other than pending or granted
class PersonalContextAuthorization < CouchRest::Model::Base

  #includes long-lived access token for oauth protocol (no refresh token) 
  belongs_to :client, SharedDataApplication 
  belongs_to :resource_owner, Account 
  property :scope, PersonalContextAuthorizationScope
  
  #oauth properties
  #self.token = ActiveSupport::SecureRandom.hex(11)
  property :access_token, String
  property :request_token, String
  property :request_expiration, Date
  property :access_expiration, Date
  property :state, Fixnum 
   
end

#scenario:
#1. application requests context authorization for specific context, scope and user
#2. user grants or denies request
#2. if grant, personal context authorization is created, state = request, request token is returned
#3. system redirects user to application redirect url with request token
#5. application swaps request token for access-token with application secret
#6. status can be updated by user to revoked at any time.
#
#see https://developers.google.com/accounts/docs/OAuth2#webserver


