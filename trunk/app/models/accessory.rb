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

class Accessory < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description
  validates_numericality_of :price
  validates_format_of :picture_type,
                      :with => /\Aimage\/jpeg\Z|\Aimage\/pjpeg\Z|\Aimage\/gif\Z|\Aimage\/png\Z|\Aimage\/x-png\Z/,
                      :message => 'not supported. Only JPEG, GIF, and PNG image formats are allowed.',
                      :if => :validate_picture_type

  has_and_belongs_to_many :phones, :join_table => "phones_accessories"

  def picture=(picture_data_field)
    return if picture_data_field.blank?
    self.picture_name = picture_data_field.original_filename
    self.picture_type = picture_data_field.content_type.chomp
    self.picture_data = picture_data_field.read
  end

  def validate_picture_type
    # Validate the format of the image only if there is one
    return ((self.picture_name != nil) || (self.picture_type != nil) || (self.picture_data != nil))
  end

  def phones_to_accessories=(phone_ids)
#    self.phones = Phone.find(phone_ids)
    @local_phone_ids = phone_ids
    if @local_phone_ids.include?("-1")
      @phones = []
    else
      @phones = Phone.find(@local_phone_ids)
    end
    self.phones = @phones
  end
end
