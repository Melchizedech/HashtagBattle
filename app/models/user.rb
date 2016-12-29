class User < ActiveRecord::Base
  has_many :battles
  has_one :token, -> { order 'created_at DESC' }, class_name: Doorkeeper::AccessToken, foreign_key: :resource_owner_id

  ###         ATTRIBUTES         ###
  ### STRING name                ###
  ### STRING access_token        ###
  ### STRING secret_access_token ###
end
