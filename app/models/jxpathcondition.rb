class Jxpathcondition < ActiveRecord::Base
  attr_accessible :description, :value, :subscription

  belongs_to :subscription
end
