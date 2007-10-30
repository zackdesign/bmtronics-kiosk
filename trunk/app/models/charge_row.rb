class ChargeRow < ActiveRecord::Base

  validates_uniqueness_of :name

  belongs_to :charges
#  has_and_belongs_to_many :charge_columns
  has_many :charge_columns

end