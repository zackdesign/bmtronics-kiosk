# == Schema Information
# Schema version: 26
#
# Table name: phones_plans
#
#  plan_id      :integer(24)   default(0)
#  phone_id     :integer(24)   default(0)
#  handset_cost :decimal(9, 2) 
#  mro          :text          
#  id           :integer(11)   not null, primary key
#

class PhonesPlans < ActiveRecord::Base
  belongs_to :plan
  belongs_to :phone

  def self.add phone_id, plan_id, handset_cost=0
    unless find_by_phone_id_and_plan_id(phone_id, plan_id)
      create :phone_id => phone_id, :plan_id => plan_id,
        :handset_cost => handset_cost
    end
  end
end
