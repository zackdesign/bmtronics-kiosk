class ChargeColumn < ActiveRecord::Base

  belongs_to :charges
  has_many :charge_rows, :dependent => :destroy

end
