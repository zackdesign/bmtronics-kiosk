# == Schema Information
# Schema version: 26
#
# Table name: charge_types
#
#  id           :integer(24)   default(0), not null, primary key
#  name         :string(255)   
#  description  :text          
#  created_at   :datetime      
#  updated_at   :datetime      
#  discontinued :boolean(1)    
#

class ChargeType < ActiveRecord::Base

  belongs_to :charges

end
