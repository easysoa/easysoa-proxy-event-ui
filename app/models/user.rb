class User < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :password, :username, :password_confirmation, :id, :role, :role_id,  :customjxpaths

  has_many :subscriptions
  has_one :nuxeotoken
  has_many :templatejxpaths

  belongs_to :role
  has_many :customjxpaths

  validates :username, :presence => true,
            :uniqueness => true

  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 3..40},
            :on => :create

  validates :password_confirmation, :confirmation => true,
            :length => {:within => 3..40},
            :allow_blank => true,
            :on => :update
  # pour verififer lauthentification
  # validates_with UserValidator

end
