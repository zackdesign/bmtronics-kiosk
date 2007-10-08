module FeaturesHelper
  
  def link_to_archive_action(feature)
    if params[:action] == 'listarch'
      link_to('Unarchive', { :action => 'unarchive', :id => feature }, :confirm => "Unarchive this feature ?", :method => :post)
    else
      confirm_message = feature.phones.empty? ? "Archive this feature ?" : "WARNING: This feature is still used by #{feature.phones.count} phone(s).\n\nArchive this feature ?"
      link_to('Archive', { :action => 'archive', :id => feature }, :confirm => confirm_message, :method => :post)
    end
  end
  
  def link_to_delete(feature)
    confirm_message = feature.phones.empty? ? "Permanently delete this feature ?" : "WARNING: Deleting this feature will also delete it from #{feature.phones.count} phone(s).\n\nPermanently delete this feature ?"
    if params[:action] == 'listarch'
      link_to('Delete', { :action => 'deletearch', :id => feature }, :confirm => confirm_message, :method => :post)
    else
      link_to('Delete', { :action => 'delete', :id => feature }, :confirm => confirm_message, :method => :post)
    end
  end
end
