module AccessoriesHelper
  
  def show_picture_if_available(accessory)
    unless accessory.picture_name.blank?
      image_tag(url_for({ :action => 'thumbnail', :id => accessory.id }), :alt => accessory.picture_name)
    else
      content_tag(:span, "None")
    end
  end
  
  def link_to_archive_action(accessory)
    if params[:action] == 'listarch'
      link_to('Unarchive', { :action => 'unarchive', :id => accessory }, :confirm => "Unarchive this accessory ?", :method => :post)
    else
      confirm_message = accessory.phones.empty? ? "Archive this accessory ?" : "WARNING: This accessory is still used by #{accessory.phones.count} phone(s).\n\nArchive this accessory ?"
      link_to('Archive', { :action => 'archive', :id => accessory }, :confirm => confirm_message, :method => :post)
    end
  end
  
  def link_to_delete(accessory)
    confirm_message = accessory.phones.empty? ? "Permanently delete this accessory ?" : "WARNING: Deleting this accessory will also delete it from #{accessory.phones.count} phone(s).\n\nPermanently delete this accessory ?"
    if params[:action] == 'listarch'
      link_to 'Delete', { :action => 'deletearch', :id => accessory }, :confirm => confirm_message, :method => :post
    else
      link_to'Delete', { :action => 'delete', :id => accessory }, :confirm => confirm_message, :method => :post
    end
  end
end
