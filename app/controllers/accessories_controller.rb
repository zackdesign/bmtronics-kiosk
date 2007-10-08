class AccessoriesController < ApplicationController
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
#    @accessory_pages, @accessories = paginate :accessories, :per_page => 10
    @accessory_pages, @accessories = paginate :accessories, { :per_page => 10, :conditions => 'active = 1' }
  end

  def listarch
    @accessory_pages, @accessories = paginate :accessories, { :per_page => 10, :conditions => 'active = 0' }
    render :action => 'list'
  end

  def show
    @accessory = Accessory.find(params[:id])
  end

  def new
    @accessory = Accessory.new
    @phones = Phone.find(:all, :order => 'name ASC')
    @current_letter = ''
    @letters = Array.new
    @tabs = Array.new
    @tab = Array.new
    @first_time = true

    @phones.each { |phone|
      if @first_time
        @tab << phone
      end

      first_letter = phone.name[0,1].upcase
      unless (first_letter == @current_letter)
        @letters.push(first_letter)
        @current_letter = first_letter
        unless @first_time
          @tabs << @tab
          @tab = Array.new(1, phone)
        end
      else
        @tab << phone
      end

      if @first_time
        @first_time = false
      end
    }

    unless @tab.empty?
      @tabs << @tab
    end
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
    @phones = Phone.find(:all, :order => 'name ASC')
    @current_letter = ''
    @letters = Array.new
    @tabs = Array.new
    @tab = Array.new
    @first_time = true

    @phones.each { |phone|
      if @first_time
        @tab << phone
      end

      first_letter = phone.name[0,1].upcase
      unless (first_letter == @current_letter)
        @letters.push(first_letter)
        @current_letter = first_letter
        unless @first_time
          @tabs << @tab
          @tab = Array.new(1, phone)
        end
      else
        @tab << phone
      end

      if @first_time
        @first_time = false
      end
    }

    unless @tab.empty?
      @tabs << @tab
    end
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

  def delete
    Accessory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def deletearch
    @accessory = Accessory.find(params[:id])
    @destroyed = @accessory.destroy
    redirect_to :action => 'listarch'
  end

  def archive
    @accessory = Accessory.find(params[:id])
    if @accessory.update_attribute(:active, false)
      flash[:notice] = 'Accessory was successfully archived.'
    else
      flash[:notice] = 'Accessory could not be archived.'
    end
    redirect_to :action => 'list'
  end

  def unarchive
    @accessory = Accessory.find(params[:id])
    if @accessory.update_attribute(:active, true)
      flash[:notice] = 'Accessory was successfully unarchived.'
    else
      flash[:notice] = 'Accessory could not be unarchived.'
    end
    redirect_to :action => 'listarch'
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
