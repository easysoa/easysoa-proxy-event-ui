class Webservicetolaunch < ActiveRecord::Base
  attr_accessible :description, :environment, :nuxeouid, :url  , :subscription

  has_and_belongs_to_many :subscription    , :class_name => 'Subscription'
end
