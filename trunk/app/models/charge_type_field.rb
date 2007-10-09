# == Schema Information
# Schema version: 26
#
# Table name: charge_type_fields
#
#  id             :integer(24)   default(0), not null, primary key
#  charge_type_id :integer(24)   
#  name           :string(255)   
#  description    :text          
#  created_at     :datetime      
#  updated_at     :datetime      
#  discontinued   :boolean(1)    
#

class ChargeTypeField < ActiveRecord::Base

  belongs_to :charge_types

end
