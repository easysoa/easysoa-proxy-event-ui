class Subscription < ActiveRecord::Base
  attr_accessible :created_at, :updated_at, :description , :webservicetolaunch, :proxy, :title , :jxpathconditions, :id

  belongs_to :subscription_type
  belongs_to :user
  belongs_to :webservicetolisten
  belongs_to :proxy
  has_many :jxpathconditions

  has_and_belongs_to_many :webservicetolaunch , :class_name => 'Webservicetolaunch'

end
