# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_new
    action_name = "new"
    action_name = "newgroup" if ["listgroups", "newgroup", "showgroup", "creategroup", "editgroup", "updategroup", "destroygroup"].include?(controller.action_name)
       
    link_to("new", :action => action_name)
  end
end
