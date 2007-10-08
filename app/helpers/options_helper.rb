module OptionsHelper
  
  def link_to_archive_action(option)
    if params[:action] == 'listarch'
      link_to('Unarchive', { :action => 'unarchive', :id => option }, :confirm => "Unarchive this option ?", :method => :post)
    else
      confirm_message = option.plans.empty? ? "Archive this option ?" : "WARNING: This option is still used by #{option.plans.count} plan(s).\n\nArchive this option ?"
      link_to('Archive', { :action => 'archive', :id => option }, :confirm => confirm_message, :method => :post)
    end
  end
  
  def link_to_delete(option)
    confirm_message = option.plans.empty? ? "Permanently delete this option ?" : "WARNING: Deleting this option will also delete it from #{option.plans.count} plan(s).\n\nPermanently delete this option ?"
    action_name = params[:action] == 'listarch' ? 'deletearch' : 'delete'
    link_to('Delete', { :action => action_name, :id => option }, :confirm => confirm_message, :method => :post)
  end
end