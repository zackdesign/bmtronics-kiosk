class ChargesController < ApplicationController

  def index
    list
    render :action => 'list'
  end
  
  def list
    @charge_pages, @charges = paginate :charge_types, :per_page => 20
  end
  
  def edit 
    @charge = ChargeType.find(params[:id])
  end
  
  def update
    @charge = ChargeType.find(params[:id])

    if @charge.update_attributes(params[:charge])
      flash[:notice] = 'Charge type was successfully updated.'
      redirect_to :action => 'show', :id => @charge
    else
      render :action => 'edit'
    end
  end
  
  def new 
    @charge = ChargeType.new
  end
  
  def create
    @charge = ChargeType.new(params[:charge])
    if @charge.save
      flash[:notice] = 'Charge type was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def destroy
    ChargeType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def show
    @charge = ChargeType.find(params[:id])
  end

end