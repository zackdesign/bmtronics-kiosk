class Accessory < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description
  validates_numericality_of :price

  has_and_belongs_to_many :phones, :join_table => "phones_accessories"
end
