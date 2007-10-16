class ChargesController < ApplicationController

  def index
    list
    render :action => 'list'
  end
  
  def list
    @charge_pages, @charges = paginate :charges, :per_page => 20
  end
  
  def edit 
    @charge = Charge.find(params[:id])
  end
  
  def update
    @charge = Charge.find(params[:id])

    if @charge.update_attributes(params[:charge])
      flash[:notice] = 'Charge type was successfully updated.'
      redirect_to :action => 'show', :id => @charge
    else
      render :action => 'edit'
    end
  end
  
  def new 
    @charge = Charge.new
  end
  
  def create
    @charge = Charge.new(params[:charge])
    if @charge.save
      flash[:notice] = 'Charge type was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def destroy
    Charge.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def show
    @charge = Charge.find(params[:id])
  end

end