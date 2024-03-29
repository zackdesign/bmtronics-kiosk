module OptionsHelper
  
  def link_to_archive_action(option)
    if params[:action] == 'listarch'
      link_to(image_tag('undo.png', :alt => 'unarchive'), { :action => 'unarchive', :id => option }, :confirm => "Unarchive this option ?", :method => :post, :title => 'unarchive', :class => 'icon')
    else
      confirm_message = option.plans.empty? ? "Archive this option ?" : "WARNING: This option is still used by #{option.plans.count} plan(s).\n\nArchive this option ?"
      link_to(image_tag('package_go.png', :alt => 'archive'), { :action => 'archive', :id => option }, :confirm => confirm_message, :class => 'icon', :method => :post, :title => 'archive')
    end
  end
  
  def link_to_delete(option)
    confirm_message = option.plans.empty? ? "Permanently delete this option ?" : "WARNING: Deleting this option will also delete it from #{option.plans.count} plan(s).\n\nPermanently delete this option ?"
    action_name = params[:action] == 'listarch' ? 'deletearch' : 'delete'
    link_to(image_tag('delete.png', :alt => 'delete'), { :action => action_name, :id => option }, :confirm => confirm_message, :class => 'icon', :title => 'delete', :method => :post)
  end
  
  def link_to_option_plans(option)
    if option.plans.count > 0
      link_to(option.plans.count, "#option#{option.id}_plans", :class => "modal") + list_related_plans(option)
    else
      content_tag(:span, option.plans.count)
    end
  end
  
  private
  def list_related_plans(option)
    result = ""
    option.plans.each{|p| result << content_tag(:li, p.name)}
    content_tag(:div, content_tag(:ul, result), :id => "option#{option.id}_plans")
  end    
end
