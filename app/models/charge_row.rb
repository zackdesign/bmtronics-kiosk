class ChargeRow < ActiveRecord::Base

  belongs_to :charges
  has_and_belongs_to_many :charge_columns

end