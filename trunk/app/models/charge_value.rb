class ChargeValue < ActiveRecord::Base

  belongs_to :plan
  
  validates_uniqueness_of :plan_id, :scope => [:charge_id, :plan_group_id]
end
