class Proxy < ActiveRecord::Base
  attr_accessible :title, :url, :subscriptions
  has_many :subscriptions , :class_name => 'Subscription'

  validates :url, :presence => true,
            :uniqueness => true

  validates :title, :presence => true,
            :uniqueness => true

end
