module PhonesHelper
  
  def show_brands(phone)
    select('phone', 'brand', Logo.find(:all).collect {|p| [ p.name, p.name ] }, :selected => phone.brand.to_s, :include_blank => true )
  end

  ##
  # used in phones/show.rhtml
  def show_thumbnail_if_available(phone)
    unless phone.picture_name.blank?
      image_tag(url_for({ :action => 'thumbnail', :id => phone.id }), :alt => phone.picture_name, :class => "thumb")
    else
      content_tag(:span, "None")
    end
  end
  
  ##
  # used in phones/list.rhtml
  def show_picture_if_available(phone)
    unless phone.picture_data.blank?
      link_to(image_tag(url_for({:action => 'picture', :id => phone.id }), { :alt => phone.picture_name, :border => 0, :class => "medium" }), url_for({ :action => 'actual', :id => phone.id }), :popup => true)
    else
      content_tag(:span, "None")
    end  
  end
  
  def link_to_phone_features(phone)
    if phone.features.count > 0
      link_to(phone.features.count, "#phone#{phone.id}_features", :class => "modal") + list_related_features(phone)
    else
      content_tag(:span, phone.features.count)
    end
  end
  
  def link_to_phone_accessories(phone)
    if phone.accessories.count > 0
      link_to(phone.accessories.count, "#phone#{phone.id}_accessories", :class => "modal") + list_related_accessories(phone)
    else
      content_tag(:span, phone.accessories.count)
    end
  end

  private
  def list_related_features(phone)
    result = ""
    phone.features.each{|f| result << content_tag(:li, f.name)}
    content_tag(:div, content_tag(:ul, result), :id => "phone#{phone.id}_features")
  end
  
  def list_related_accessories(phone)
    result = ""
    phone.accessories.each{|a| result << content_tag(:li, a.name)}
    content_tag(:div, content_tag(:ul, result), :id => "phone#{phone.id}_accessories")
  end

end
