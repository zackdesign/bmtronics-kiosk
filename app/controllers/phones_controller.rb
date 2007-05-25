class PhonesController < ApplicationController

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
    @phone_pages, @phones = paginate :phones, :per_page => 10
  end

  def show
    @phone = Phone.find(params[:id])
  end

  def new
    @phone = Phone.new
    @accessories = Accessory.find(:all)
    @features = Feature.find(:all)
  end

  def create
    @phone = Phone.new(params[:phone])
    if @phone.save
      flash[:notice] = 'Phone was successfully created.'
      redirect_to :action => 'list'
    else
      if (@phone.errors.invalid?(:picture_name) ||
          @phone.errors.invalid?(:picture_type) ||
          @phone.errors.invalid?(:picture_data))
        # Remove the image from the phone if it is found that the validation fails
        @phone.picture_name = nil
        @phone.picture_type = nil
        @phone.picture_data = nil
      end
      render :action => 'new'
    end
  end

  def edit
    @phone = Phone.find(params[:id])
    @accessories = Accessory.find(:all)
    @features = Feature.find(:all)
  end

  def update
    @phone = Phone.find(params[:id])
    @remove = params[:remove_picture]

    @old_pic_name = nil
    @old_pic_type = nil
    @old_pic_data = nil

    unless @remove.blank?
      # If the "Remove picture" checkbox has been ticked, set the :picture parameter to nil
      # so that the picture=() method exits without creating the :picture_name, :picture_type,
      # and :picture_data attributes, and them create them manually here instead. This will
      # cause the picture to be removed from the database when the phone is updated
      params[:phone][:picture] = nil
      params[:phone][:picture_name] = nil
      params[:phone][:picture_type] = nil
      params[:phone][:picture_data] = nil
    else
      # Otherwise keep a copy of the phone's current picture information, so if the :picture
      #parameter is found to be invalid then the :picture_name, :picture_type, and :picture_data
      # attributes can be restored
      @old_pic_name = @phone.picture_name
      @old_pic_type = @phone.picture_type
      @old_pic_data = @phone.picture_data
    end

    if @phone.update_attributes(params[:phone])
      flash[:notice] = 'Phone was successfully updated.'
      redirect_to :action => 'show', :id => @phone
    else
      # Restore the previous image
      @phone.picture_name = @old_pic_name
      @phone.picture_type = @old_pic_type
      @phone.picture_data = @old_pic_data
      render :action => 'edit'
    end
  end

  def destroy
    Phone.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def thumbnail
    # Create a thumbnail image of the uploaded picture for the phone list
    @phone = Phone.find(params[:id])
    image = Magick::Image.from_blob(@phone.picture_data).first
    thumb = image.thumbnail(48, 48)
    send_data thumb.to_blob, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end

  def picture
    # Create a resized image of the uploaded picture for when the phone is shown
    @phone = Phone.find(params[:id])
    image = Magick::Image.from_blob(@phone.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 300
      thumb = image
    else
      thumb = image.resize_to_fit(300, 300)
    end
    send_data thumb.to_blob, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end

  def actual
    # Send the uploaded image actual size to the browser
    @phone = Phone.find(params[:id])
    send_data @phone.picture_data, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end
end
