module PlanGroupsHelper
  
  def link_to_group_plans(plan_group)
    if plan_group.plans.count > 0
      link_to(plan_group.plans.count, "#group#{plan_group.id}_features", :class => "modal") + list_related_plans(plan_group)
    else
      content_tag(:span, plan_group.plans.count)
    end
  end
  
  def link_to_charge(plan_group)
      link_to image_tag('money_dollar.png', :alt => 'charges'), { :controller => 'charges', :action => 'list', :id => plan_group, :name => plan_group.name }, :class => 'icon', :title => 'call rates'
  end
  
  private
  def list_related_plans(plan_group)
    result = ""
    plan_group.plans.each{|p| result << content_tag(:li, p.name)}
    content_tag(:div, content_tag(:ul, result), :id => "group#{plan_group.id}_features")
  end
end
