class FeaturesController < ApplicationController
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
    @features = Feature.paginate :page => params[:page], :per_page => 10, :order => 'name ASC', :conditions => 'active = 1'
  end

  def listarch
    @features = Feature.paginate :page => params[:page], :per_page => 10, :order => 'name ASC', :conditions => 'active = 0'
    render :action => 'list'
  end

  def show
    @feature = Feature.find(params[:id])
  end

  def new
    @feature = Feature.new
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
    @feature = Feature.new(params[:feature])
    if @feature.save
      flash[:notice] = 'Feature was successfully created.'
      redirect_to :action => 'list'
    else
      if (@feature.errors.invalid?(:picture_name) ||
          @feature.errors.invalid?(:picture_type) ||
          @feature.errors.invalid?(:picture_data))
        # Remove the image from the feature if it is found that the validation fails
        @feature.picture_name = nil
        @feature.picture_type = nil
        @feature.picture_data = nil
      end 
      redirect_to :action => 'new'
    end
  end

  def edit
    @feature = Feature.find(params[:id])
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
    @feature = Feature.find(params[:id])
    @remove = params[:remove_picture]

    @old_pic_name = nil
    @old_pic_type = nil
    @old_pic_data = nil

    unless @remove.blank?
      # If the "Remove picture" checkbox has been ticked, set the :picture parameter to nil
      # so that the picture=() method exits without creating the :picture_name, :picture_type,
      # and :picture_data attributes, and them create them manually here instead. This will
      # cause the picture to be removed from the database when the feature is updated
      params[:feature][:picture] = nil
      params[:feature][:picture_name] = nil
      params[:feature][:picture_type] = nil
      params[:feature][:picture_data] = nil
    else
      # Otherwise keep a copy of the feature's current picture information, so if the :picture
      #parameter is found to be invalid then the :picture_name, :picture_type, and :picture_data
      # attributes can be restored
      @old_pic_name = @feature.picture_name
      @old_pic_type = @feature.picture_type
      @old_pic_data = @feature.picture_data
    end
    if @feature.update_attributes(params[:feature])
      flash[:notice] = 'Feature was successfully updated.'
      redirect_to :action => 'show', :id => @feature
    else
      # Restore the previous image
      @feature.picture_name = @old_pic_name
      @feature.picture_type = @old_pic_type
      @feature.picture_data = @old_pic_data
      render :action => 'edit'
    end
  end

  def delete
    @feature = Feature.find(params[:id])
    @destroyed = @feature.destroy
    redirect_to :action => 'list'
  end

  def deletearch
    @feature = Feature.find(params[:id])
    @destroyed = @feature.destroy
    redirect_to :action => 'listarch'
  end

  def archive
    @feature = Feature.find(params[:id])
    if @feature.update_attribute(:active, false)
      flash[:notice] = 'Feature was successfully archived.'
    else
      flash[:notice] = 'Feature could not be archived.'
    end
    redirect_to :action => 'list'
  end

  def unarchive
    @feature = Feature.find(params[:id])
    if @feature.update_attribute(:active, true)
      flash[:notice] = 'Feature was successfully unarchived.'
    else
      flash[:notice] = 'Feature could not be unarchived.'
    end
    redirect_to :action => 'listarch'
  end


  def thumbnail
    # Create a thumbnail image of the uploaded picture for the feature list
    @feature = Feature.find(params[:id])
    image = Magick::Image.from_blob(@feature.picture_data).first
    thumb = image.thumbnail(48, 48)
    send_data thumb.to_blob, :filename => @feature.picture_name,
              :type => @feature.picture_type, :disposition => "inline"
  end

  def picture
    # Create a resized image of the uploaded picture for when the feature is shown
    @feature = Feature.find(params[:id])
    image = Magick::Image.from_blob(@feature.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 300
      thumb = image
    else
      thumb = image.resize_to_fit(300, 300)
    end
    send_data thumb.to_blob, :filename => @feature.picture_name,
              :type => @feature.picture_type, :disposition => "inline"
  end


  def actual
    # Send the uploaded image actual size to the browser
    @feature = Feature.find(params[:id])
    send_data @feature.picture_data, :filename => @feature.picture_name,
              :type => @feature.picture_type, :disposition => "inline"
  end
end
