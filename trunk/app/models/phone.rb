class Phone < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description
  validates_numericality_of :outright
  validates_format_of :picture_type,
                      :with => /\Aimage\/jpeg\Z|\Aimage\/pjpeg\Z|\Aimage\/gif\Z|\Aimage\/png\Z|\Aimage\/x-png\Z/,
                      :message => 'not supported. Only JPEG, GIF, and PNG image formats are allowed.',
                      :if => :validate_picture_type

  has_and_belongs_to_many :accessories, :join_table => "phones_accessories"
  has_and_belongs_to_many :features, :join_table => "phones_features"

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

  def accessories_to_phones=(accessory_ids)
#    self.accessories = Accessory.find(accessory_ids)
    @local_accessory_ids = accessory_ids
    if @local_accessory_ids.include?("-1")
      @accessories = []
    else
      @accessories = Accessory.find(@local_accessory_ids)
    end
    self.accessories = @accessories
  end

  def features_to_phones=(feature_ids)
#    self.features = Feature.find(feature_ids)
    @local_feature_ids = feature_ids
    if @local_feature_ids.include?("-1")
      @features = []
    else
      @features = Feature.find(@local_feature_ids)
    end
    self.features = @features
  end
end
