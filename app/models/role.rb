class Role < ActiveRecord::Base
  attr_accessible :title, :id

  has_many :users

end
