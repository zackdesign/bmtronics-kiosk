class ChargesController < ApplicationController

  def index
    list
    render :action => 'list'
  end
  
  def list
    @charge_pages, @charges = paginate :charge_types, :per_page => 20
  end
  
  def new 
    @charge = ChargeType.new
  end
  
  def destroy
    ChargeType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

end