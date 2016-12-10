class Hashtag < ActiveRecord::Base
  has_many :counts
  has_many :battles, through: :counts
end
