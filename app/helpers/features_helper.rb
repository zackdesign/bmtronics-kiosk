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
    action_name = params[:action] == 'listarch' ? 'deletearch' : 'delete'
    link_to('Delete', { :action => action_name, :id => feature }, :confirm => confirm_message, :method => :post)
  end
  
  def link_to_feature_phones(feature)
    if feature.phones.count > 0
      link_to(feature.phones.count, "#feature#{feature.id}_phones", :class => "modal") + list_related_phones(feature)
    else
      content_tag(:span, feature.phones.count)
    end
  end
  
  private
  def list_related_phones(feature)
    result = ""
    feature.phones.each{|p| result << content_tag(:li, p.name)}
    content_tag(:div, content_tag(:ul, result), :id => "feature#{feature.id}_phones")
  end
end
