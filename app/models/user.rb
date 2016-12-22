class User < ActiveRecord::Base
  has_many :battles


  ###         ATTRIBUTES         ###
  ### STRING mail                ###
  ### STRING access_token        ###
  ### STRING secret_access_token ###
end
