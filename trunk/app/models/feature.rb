# == Schema Information
# Schema version: 26
#
# Table name: features
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  description :text          
#  created_at  :datetime      
#  updated_at  :datetime      
#  active      :boolean(1)    default(TRUE)
#

class Feature < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :phones, :join_table => "phones_features"

  def phones_to_features=(phone_ids)
    @local_phone_ids = phone_ids
    if @local_phone_ids.include?("-1")
      @phones = []
    else
      @phones = Phone.find(@local_phone_ids)
    end
    self.phones = @phones
  end
end
