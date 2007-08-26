class Plan < ActiveRecord::Base

  has_and_belongs_to_many :phones
  belongs_to :plan_group
  has_many :charges

  def plan_category_set=(new_categories)
    @local_new_categories = new_categories
#    breakpoint
    categories = @local_new_categories.join(",")
    self.categories = categories;
  end

#  def plan_phones_handset_cost_set=(new_handset_costs)
#    @local_new_handset_costs = new_handset_costs
#    breakpoint
#  end

  def plan_phones_handset_set=(new_handsets)
    @local_new_handsets = new_handsets
#    breakpoint
    @ids = nil
    @costs = nil
    if @local_new_handsets.length == 1
      @phones = []
    else
      @local_new_handsets.delete_if { |h| h == "-1|-1" }
      @ids = @local_new_handsets.collect { |h| h.split('|').first }
      @costs = @local_new_handsets.collect { |h| h.split('|').last }
      @phones = Phone.find(@ids)
#      for phone in @phones
#        index = @ids.index(phone.id)
#        phone.handset_cost = @costs[index]
#      end
    end
    self.phones = @phones
#    breakpoint
  end
end