class FeaturesController < ApplicationController

  layout "main"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @feature_pages, @features = paginate :features, :per_page => 10
    @feature_pages, @features = paginate :features, { :per_page => 10, :conditions => 'active = 1' }
  end

  def listarch
    @feature_pages, @features = paginate :features, { :per_page => 10, :conditions => 'active = 0' }
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
      render :action => 'new'
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
    if @feature.update_attributes(params[:feature])
      flash[:notice] = 'Feature was successfully updated.'
      redirect_to :action => 'show', :id => @feature
    else
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
end
