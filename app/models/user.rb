class User < ActiveRecord::Base
  has_many :battles


  ###         ATTRIBUTES         ###
  ### STRING name                ###
  ### STRING access_token        ###
  ### STRING secret_access_token ###
end
