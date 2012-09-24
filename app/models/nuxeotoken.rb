class Nuxeotoken < ActiveRecord::Base
  attr_accessible :key, :secret, :user
  belongs_to :user

end
