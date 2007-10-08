module PhonesHelper
  
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
