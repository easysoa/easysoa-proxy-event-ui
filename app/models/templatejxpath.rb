class Templatejxpath < ActiveRecord::Base
  attr_accessible :value, :description

  validates :value, :presence => {:message => 'should not be empty'}
  validates :description, :presence => {:message => 'should not be empty'}
  validate :value_should_be_present
  belongs_to :user


  def value_should_be_present
    if value['XXX'].nil?
      errors.add(:value, "should content XXX")
    end
  end

end
