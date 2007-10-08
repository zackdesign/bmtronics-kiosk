# == Schema Information
# Schema version: 26
#
# Table name: accessories
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  description  :text          
#  price        :decimal(9, 2) default(0.0), not null
#  created_at   :datetime      
#  updated_at   :datetime      
#  outofstock   :boolean(1)    
#  discontinued :boolean(1)    
#  picture_name :string(255)   
#  picture_type :string(255)   default("image/jpeg")
#  picture_data :binary        
#  active       :boolean(1)    default(TRUE)
#  buy_price    :decimal(9, 2) 
#  supplier     :text          
#  partnum      :string(255)   
#  corp_price   :decimal(9, 2) 
#

class Accessories < ActiveRecord::Base
end
