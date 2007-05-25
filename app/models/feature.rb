class Feature < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description

#  has_and_belongs_to_many :phones, :join_table => "phones_features", :before_remove => :check_not_inuse
#  has_and_belongs_to_many :phones, :join_table => "phones_features", :before_destroy => :check_not_inuse
  has_and_belongs_to_many :phones, :join_table => "phones_features"

#  before_destroy :check_not_inuse

#  def check_not_inuse()
#    unless phones.empty? then
#      errors.add :name, "The #{:name} feature can\'t be deleted since it\'s attached to one or more phones."
#    end
#
#    return phones.empty?
#  end

  def phones_to_features=(phone_ids)
    self.phones = Phone.find(phone_ids)
  end
end
