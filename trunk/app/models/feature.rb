class Feature < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description

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
