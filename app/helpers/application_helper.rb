# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_new
    link_to("new", :action => "new")
  end
  
  def link_to_newgroup
    link_to("new group", :controller => 'plan_groups', :action => "new")
  end
  
  def link_to_view
    link_to("view", :action => "list")
  end
  
  def link_to_viewgroup
    link_to("view group", :controller => 'plan_groups', :action => "list")
  end
  
  def link_to_archive
    link_to("archive", :action => "listarch")
  end
  
  ##
  # create an ul with the categories associted with variable
  # used in plans/list*.rhtml and plans/show*.rhtml
  def list_categories(variable)
    if !variable.categories.empty?
      cat_list = ""
      variable.categories.split(',').each{|cat| cat_list << content_tag(:li, cat.capitalize, :class => cat.downcase)}
      content_tag(:ul, cat_list, :class => "categories")
    else
      content_tag(:span, "None")
    end
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
  
  def various_javascript_functions
    js = <<END_OF_STATEMENT
    <!--
    function MM_swapImgRestore() { //v3.0
      var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
    }

    function MM_findObj(n, d) { //v4.01
      var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
      if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
      for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
      if(!x && d.getElementById) x=d.getElementById(n); return x;
    }

    function MM_swapImage() { //v3.0
      var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
       if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
    }
    function inputFocus(ref, defaultString) {
    	if (ref.value == defaultString) {
    		ref.value = '';
    	}
    }

    function inputBlur(ref, defaultString) {
    	if (ref.value == '')  {
    		ref.value = defaultString;
    	}
    }
END_OF_STATEMENT
    javascript_tag(js)
  end
  
  ##
  # links with images for basic functions
  # used in list.rhtml 
  def link_to_show(roo)
    link_to(image_tag('show.png', :alt => 'show'), {:action => 'show', :id => roo}, :class => 'icon', :title => 'show')
  end

  def link_to_edit(roo)
    link_to(image_tag('edit.png', :alt => 'edit'), {:action => 'edit', :id => roo}, :class => 'icon', :title => 'edit')
  end
  
  def link_to_delete(roo, confirm = "Are you sure?")
    link_to(image_tag('delete.png', :alt => 'delete'), { :action => 'destroy', :id => roo }, :confirm => confirm, :class => 'icon', :title => 'delete', :method => :post)
  end
  
  ##
  # submit button
  def form_button(text, type = 'submit', image='tick.png', css_class = 'positive')
    content_tag(:button, image_tag(image) + text, :type => type, :class => css_class)
  end
  
  ## Shorten all descriptions when listing...
  def shorten (string, word_limit = 10)
    words = string.split(/\s/)
    if words.size >= word_limit
      words[0,(word_limit-1)].join(" ") + '...'
    else 
      string
    end
  end

end
