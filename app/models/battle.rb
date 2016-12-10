class Battle < ActiveRecord::Base
  belongs_to :user
  has_many :counts
  has_many :hashtags, through: :counts
end
