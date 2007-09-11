class Option < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description

  has_and_belongs_to_many :plans, :join_table => "plans_options"

  def plans_to_options=(plan_ids)
    @local_plan_ids = plan_ids
    if @local_plan_ids.include?("-1")
      @plans = []
    else
      @plans = Plan.find(@local_plan_ids)
    end
    self.plans = @plans
  end
end
