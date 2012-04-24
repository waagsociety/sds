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

#checks for expiration, validity of scope, grantee and owner, 
#can only be called by the logged in end user
#updates state to GRANTED
def grant
end

#updates state to DENIED
def deny
end

#scenario:
#1. application requests context authorization for specific context, scope and user
#2. personal context authorization is created, state = request, request token is returned
#3. application redirects user with request token
#4. user grants or denies token, (if within the request expiration date), else state is updated to expired
#5. if granted, state is updated to granted, access_token is returned, with access_expiration
#6. status can be updated by user to revoked at any time.


