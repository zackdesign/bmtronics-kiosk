module FeaturesHelper
  

  ##
  # used in features/show.rhtml
  def show_picture_if_available(feature)
    unless feature.picture_data.blank?
      link_to(image_tag(url_for({ :action => 'picture', :id => feature.id }), { :alt => feature.picture_name, :border => 0, :class => "medium" }), url_for({ :action => 'actual', :id => feature.id }), :popup => true)
    else
      content_tag(:span, "None")
    end
  end
  
  ##
  # used in features/list.rhtml
  def show_thumbnail_if_available(feature)
    unless feature.picture_name.blank?
      image_tag(url_for({ :action => 'thumbnail', :id => feature.id }), :alt => feature.picture_name, :class => "thumb")
    else
      content_tag(:span, "None")
    end
  end


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
    link_to(image_tag('delete', :alt => 'delete'), { :action => action_name, :id => feature }, :confirm => confirm_message, :class => 'icon', :title => 'delete', :method => :post)
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
