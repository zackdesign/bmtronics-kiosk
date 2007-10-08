# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_new
    action_name = "new"
    action_name = "newgroup" if ["listgroups", "newgroup", "showgroup", "creategroup", "editgroup", "updategroup", "destroygroup"].include?(controller.action_name)
       
    link_to("new", :action => action_name)
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
