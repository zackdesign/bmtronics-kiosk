module LogosHelper
  
  ##
  # used in logos/show.rhtml
  def show_picture_if_available(logo)
    unless logo.picture_data.blank?
      link_to(image_tag(url_for({ :action => 'picture', :id => logo.id }), { :alt => logo.picture_name, :border => 0, :class => "medium" }), url_for({ :action => 'actual', :id => logo.id }), :popup => true)
    else
      content_tag(:span, "None")
    end
  end
  
  ##
  # used in logos/list.rhtml
  def show_thumbnail_if_available(logo)
    unless logo.picture_name.blank?
      image_tag(url_for({ :action => 'thumbnail', :id => logo.id }), :alt => logo.picture_name, :class => "thumb")
    else
      content_tag(:span, "None")
    end
  end
  
  def link_to_archive_action(logo)
    if params[:action] == 'listarch'
      link_to('Unarchive', { :action => 'unarchive', :id => logo }, :confirm => "Unarchive this logo ?", :method => :post)
    end
  end
  
  def link_to_delete(logo)
    action_name = params[:action] == 'listarch' ? 'deletearch' : 'delete'
    link_to image_tag('delete.png', :alt => 'delete'), { :action => action_name, :id => logo },  :class => 'icon', :title => 'delete', :method => :post
  end
  
  def link_to_logo_phones(logo)
    if logo.phones.count > 0
      link_to(logo.phones.count, "#logo#{logo.id}_phones", :class => "modal") + list_related_phones(logo)
    else
      content_tag(:span, logo.phones.count)
    end
  end
  
  private
  def list_related_phones(logo)
    result = ""
    logo.phones.each{|p| result << content_tag(:li, p.name)}
    content_tag(:div, content_tag(:ul, result), :id => "logo#{logo.id}_phones")
  end
end
