class Webservicetolisten < ActiveRecord::Base
  attr_accessible :archipath, :date, :description, :environment, :nuxeouid, :title, :url
  has_many :subscriptions
end
