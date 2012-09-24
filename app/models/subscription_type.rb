class SubscriptionType < ActiveRecord::Base
  attr_accessible :description, :title
  has_many :subscriptions

end
