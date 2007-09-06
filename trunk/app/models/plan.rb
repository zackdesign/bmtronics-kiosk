class Plan < ActiveRecord::Base

  has_and_belongs_to_many :phones
  belongs_to :plan_group
  has_many :charges

  def plan_category_set=(new_categories)
    @local_new_categories = new_categories
    categories = @local_new_categories.join(",")
    self.categories = categories;
  end

  def plan_phones_handset_set=(new_handsets)
    @local_new_handsets = new_handsets
    @ids = nil
    @costs = nil

    @local_new_handsets.delete_if { |hand| hand == "-1|-1" }
    @phone_ids = @local_new_handsets.collect { |hand| hand.split('|').first.to_i }
    @costs = @local_new_handsets.collect { |hand| hand.split('|').last.to_f }

    # Remove entries in the Phones Plans join table
    self.phones.each { |phone|
      unless phone == nil
        @phone_plan = PhonesPlans.find_by_plan_id_and_phone_id(self.id, phone.phone_id)
        unless @phone_plan == nil
          @phone_plan.destroy
        end
      end
    }

    # Find or create entries in the Phones Plans join table      
    @new_phones_plans = @phone_ids.collect { |pid|
      PhonesPlans.find_or_create_by_plan_id_and_phone_id(self.id, pid)
    }

    # Now modify the Phones Plans table entries found / created above with the additional information
    # given by the user i.e. handset cost, MRO, etc.
    for pp in 0..(@new_phones_plans.length - 1)
      @new_phones_plans[pp].handset_cost = @costs[pp]
      @new_phones_plans[pp].save
    end
  end

  def plan_charge_type=(new_charge_type)
    @local_new_charge_type = new_charge_type

    if self.charge_type == @local_new_charge_type.to_i
      return
    end

    if @local_new_charge_type == ''
      @local_new_charge_type = nil
    end

    @new_charges = []
    unless @local_new_charge_type == nil
      @new_charge_fields = ChargeTypeField.find(:all, :conditions => 'charge_type_id = ' + @local_new_charge_type.to_s)
      @new_charges = @new_charge_fields.collect { |cf|
        @new_charge = Charge.new
        @new_charge.plan_id = self.id
        @new_charge.charge_type_field = cf.id
        @new_charge
      }
    end

    if self.charges.length > 0
      self.charges.each { |c| c.destroy }
    end
    self.charges = @new_charges
    self.charge_type = @local_new_charge_type
  end

  def charges_values=(new_charges_values)
    @local_new_charges_values = new_charges_values

    if self.charges.length > 0 && self.charges.length == @local_new_charges_values.length
      for @i in 0..(self.charges.length - 1)
        @new_charge = Charge.new(self.charges[@i].attributes)
        @new_charge.value = @local_new_charges_values[@i]
        self.charges[@i].destroy
        self.charges[@i] = @new_charge
      end
    end
  end
end