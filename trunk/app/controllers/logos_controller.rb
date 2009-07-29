class LogosController < ApplicationController
  require 'RMagick'
  include Magick

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @logos = Logo.paginate :page => params[:page], :per_page => 10, :order => 'name ASC'
  end

  def new
    @logo = Logo.new
  end

  def create
    @logo = Logo.new(params[:logo])
    if @logo.save
      flash[:notice] = 'Logo was successfully created.'
      redirect_to :action => 'list'
    else
      if (@logo.errors.invalid?(:picture_name) ||
          @logo.errors.invalid?(:picture_type) ||
          @logo.errors.invalid?(:picture_data))
        # Remove the image from the logo if it is found that the validation fails
        @logo.picture_name = nil
        @logo.picture_type = nil
        @logo.picture_data = nil
      end
      render :action => 'new'
    end
  end

  def edit
    @logo = Logo.find(params[:id])
  end

  def update
    @logo = Logo.find(params[:id])
    @remove = params[:remove_picture]

    @old_pic_name = nil
    @old_pic_type = nil
    @old_pic_data = nil

    unless @remove.blank?
      # If the "Remove picture" checkbox has been ticked, set the :picture parameter to nil
      # so that the picture=() method exits without creating the :picture_name, :picture_type,
      # and :picture_data attributes, and them create them manually here instead. This will
      # cause the picture to be removed from the database when the logo is updated
      params[:logo][:picture] = nil
      params[:logo][:picture_name] = nil
      params[:logo][:picture_type] = nil
      params[:logo][:picture_data] = nil
    else
      # Otherwise keep a copy of the logo's current picture information, so if the :picture
      #parameter is found to be invalid then the :picture_name, :picture_type, and :picture_data
      # attributes can be restored
      @old_pic_name = @logo.picture_name
      @old_pic_type = @logo.picture_type
      @old_pic_data = @logo.picture_data
    end


    if @logo.update_attributes(params[:logo])
      flash[:notice] = 'logo was successfully updated.'
      redirect_to :action => 'list'
    else
      # Restore the previous image
      @logo.picture_name = @old_pic_name
      @logo.picture_type = @old_pic_type
      @logo.picture_data = @old_pic_data
      render :action => 'edit'
    end
  end

  def delete
    Logo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def plasma
    
      @logos = Logo.find(:all, :order=> "name ASC")
    
    end
    
    def update_plasma
     
      params[:logo].each do |id, key|
        @logo = Logo.find(id)
        @logo.update_attributes(key)
      end
      
      redirect_to :action => 'plasma'
  end

  def thumbnail
    # Create a thumbnail image of the uploaded picture for the logo list
    @logo = Logo.find(params[:id])
    image = Magick::Image.from_blob(@logo.picture_data).first
    thumb = image.thumbnail(48, 48)
    send_data thumb.to_blob, :filename => @logo.picture_name,
              :type => @logo.picture_type, :disposition => "inline"
  end

  def picture
    # Create a resized image of the uploaded picture for when the logo is shown
    @logo = Logo.find(params[:id])
    image = Magick::Image.from_blob(@logo.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 300
      thumb = image
    else
      thumb = image.resize_to_fit(300, 300)
    end
    send_data thumb.to_blob, :filename => @logo.picture_name,
              :type => @logo.picture_type, :disposition => "inline"
  end


  def actual
    # Send the uploaded image actual size to the browser
    @logo = Logo.find(params[:id])
    send_data @logo.picture_data, :filename => @logo.picture_name,
              :type => @logo.picture_type, :disposition => "inline"
  end
end
