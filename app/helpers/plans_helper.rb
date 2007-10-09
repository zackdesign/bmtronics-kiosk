module PlansHelper
  
  def charge_type(plan)
    plan.charge_type != nil ? ChargeType.find(plan.charge_type).name : "None"
  end
  
  def link_to_plan_phones(plan)
    if plan.phones.count > 0
      link_to(plan.phones.count, "#plan#{plan.id}_phones", :class => "modal") + list_related_phones(plan)
    else
      content_tag(:span, plan.phones.count)
    end
  end
  
  private
  def list_related_phones(plan)
    result = ""
    plan.phones.each{|p| result << content_tag(:li, p.name)}
    content_tag(:div, content_tag(:ul, result), :id => "plan#{plan.id}_phones")
  end
  
end
