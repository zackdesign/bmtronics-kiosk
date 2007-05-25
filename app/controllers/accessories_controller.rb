class AccessoriesController < ApplicationController

  require 'RMagick'
  include Magick

  layout "main"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @accessory_pages, @accessories = paginate :accessories, :per_page => 10
  end

  def show
    @accessory = Accessory.find(params[:id])
  end

  def new
    @accessory = Accessory.new
    @phones = Phone.find(:all)
  end

  def create
    @accessory = Accessory.new(params[:accessory])
    if @accessory.save
      flash[:notice] = 'Accessory was successfully created.'
      redirect_to :action => 'list'
    else
      if (@accessory.errors.invalid?(:picture_name) ||
          @accessory.errors.invalid?(:picture_type) ||
          @accessory.errors.invalid?(:picture_data))
        # Remove the image from the accessory if it is found that the validation fails
        @accessory.picture_name = nil
        @accessory.picture_type = nil
        @accessory.picture_data = nil
      end
      render :action => 'new'
    end
  end

  def edit
    @accessory = Accessory.find(params[:id])
    @phones = Phone.find(:all)
  end

  def update
    @accessory = Accessory.find(params[:id])
    @remove = params[:remove_picture]

    @old_pic_name = nil
    @old_pic_type = nil
    @old_pic_data = nil

    unless @remove.blank?
      # If the "Remove picture" checkbox has been ticked, set the :picture parameter to nil
      # so that the picture=() method exits without creating the :picture_name, :picture_type,
      # and :picture_data attributes, and them create them manually here instead. This will
      # cause the picture to be removed from the database when the accessory is updated
      params[:accessory][:picture] = nil
      params[:accessory][:picture_name] = nil
      params[:accessory][:picture_type] = nil
      params[:accessory][:picture_data] = nil
    else
      # Otherwise keep a copy of the accessory's current picture information, so if the :picture
      #parameter is found to be invalid then the :picture_name, :picture_type, and :picture_data
      # attributes can be restored
      @old_pic_name = @accessory.picture_name
      @old_pic_type = @accessory.picture_type
      @old_pic_data = @accessory.picture_data
    end

    if @accessory.update_attributes(params[:accessory])
      flash[:notice] = 'Accessory was successfully updated.'
      redirect_to :action => 'show', :id => @accessory
    else
      # Restore the previous image
      @accessory.picture_name = @old_pic_name
      @accessory.picture_type = @old_pic_type
      @accessory.picture_data = @old_pic_data
      render :action => 'edit'
    end
  end

  def destroy
    Accessory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def thumbnail
    # Create a thumbnail image of the uploaded picture for the accessory list
    @accessory = Accessory.find(params[:id])
    image = Magick::Image.from_blob(@accessory.picture_data).first
    thumb = image.thumbnail(48, 48)
    send_data thumb.to_blob, :filename => @accessory.picture_name,
              :type => @accessory.picture_type, :disposition => "inline"
  end

  def picture
    # Create a resized image of the uploaded picture for when the accessory is shown
    @accessory = Accessory.find(params[:id])
    image = Magick::Image.from_blob(@accessory.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 300
      thumb = image
    else
      thumb = image.resize_to_fit(300, 300)
    end
    send_data thumb.to_blob, :filename => @accessory.picture_name,
              :type => @accessory.picture_type, :disposition => "inline"
  end

  def actual
    # Send the uploaded image actual size to the browser
    @accessory = Accessory.find(params[:id])
    send_data @accessory.picture_data, :filename => @accessory.picture_name,
              :type => @accessory.picture_type, :disposition => "inline"
  end
end
