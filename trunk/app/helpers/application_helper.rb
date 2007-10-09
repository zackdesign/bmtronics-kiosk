# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_new
    action_name = "new"
       
    link_to("new", :action => action_name)
  end
  
  def link_to_newgroup
    action_name = "newgroup"
    
    link_to("new group", :action => action_name)
  end
  
  def link_to_view
    link_to("view", :action => "list")
  end
  
  def link_to_viewgroup
    link_to("view group", :action => "listgroups")
  end
  
  def link_to_archive
    link_to("archive", :action => "listarch")
  end
  
  ##
  # create an ul with the categories associted with variable
  # used in plans/list*.rhtml and plans/show*.rhtml
  def list_categories(variable)
    if !variable.categories.empty?
      cat_list = ""
      variable.categories.split(',').each{|cat| cat_list << content_tag(:li, cat.capitalize, :class => cat.downcase)}
      content_tag(:ul, cat_list, :class => "categories")
    else
      content_tag(:span, "None")
    end
  end
  
  ##
  # needed to setup modal window
  def control_modal_setup
    js = <<END_OF_STATEMENT
          document.getElementsByClassName('modal').each(function(link){
              new Control.Modal(link, {opacity: 0.8, position: 'relative', offsetTop: 20, hover: true});
          });
END_OF_STATEMENT
    javascript_tag(js)
  end
end
