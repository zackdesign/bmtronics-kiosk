class PlanGroup < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description

  has_many :plans

  def categories_chk=(cat_strs)
    @local_categories_strs = cat_strs
#    breakpoint
    self.categories = @local_categories_strs.join(',')
#    breakpoint
  end
end
