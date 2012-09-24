class Customjxpath < ActiveRecord::Base

  attr_accessible :user, :value, :description

  validates :value, :presence => {:message => " Should not be empty"}

  validates :description, :presence => {:message => " Should not be empty"}


  belongs_to :user
end
