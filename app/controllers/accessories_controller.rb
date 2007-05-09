class AccessoriesController < ApplicationController

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
  end

  def create
    @accessory = Accessory.new(params[:accessory])
    if @accessory.save
      flash[:notice] = 'Accessory was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @accessory = Accessory.find(params[:id])
  end

  def update
    @accessory = Accessory.find(params[:id])
    if @accessory.update_attributes(params[:accessory])
      flash[:notice] = 'Accessory was successfully updated.'
      redirect_to :action => 'show', :id => @accessory
    else
      render :action => 'edit'
    end
  end

  def destroy
    Accessory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
