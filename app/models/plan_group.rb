class PlanGroup < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description

  has_many :plans, :foreign_key => "plan_group"

  def categories_chk=(cat_strs)
    @local_categories_strs = cat_strs
#    breakpoint
    self.categories = @local_categories_strs.join(',')
#    breakpoint
  end

  def plans_ids=(new_plan_ids)
    @local_new_plan_ids = new_plan_ids
    self.plans = Plan.find(@local_new_plan_ids)
  end
end
