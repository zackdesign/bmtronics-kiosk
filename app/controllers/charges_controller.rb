class ChargesController < ApplicationController

  def index
    list
    render :action => 'list'
  end
  
  def list
    @plans = Plan.find(:all, :conditions => { :plan_group => params[:id] })
    @charges = ChargeValue.find(:all, :conditions => {:plan_group_id => params[:id]})
    @name = params[:name]
    @id = params[:id]
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
    @charge = ChargeValue.new
    @plans = Plan.find(:all, :conditions => { :plan_group => params[:id] })
    @name = params[:name]
    @cname = params[:cname]
    @id = params[:id]
    @charge_id = params[:charge]
  end
  
  def new_row
      @charge = ChargeValue.new
      @plans = Plan.find(:all, :conditions => { :plan_group => params[:id] })
      @charges = Charge.find(:all)
      @name = params[:name]
      @id = params[:id]
      @charge_id = params[:charge]
  end
  
  def create
    @charge = ChargeValue.new(params[:charge_values])
    if @charge.save
      flash[:notice] = 'Charge was successfully created.'
      redirect_to :action => 'list', :id => params[:charge_values][:plan_group_id], :name => params[:charge_name]
    else
      flash[:notice] = 'Charge unable to be created. Choose a Plan you have not created a column value for.'
      redirect_to :action => 'new', :id => params[:charge_values][:plan_group_id], :name => params[:charge_name], :charge => params[:charge_values][:charge_id]
    end
  end
  
def create_row
    unless params[:name].empty?
        ch = Charge.new('name' =>params[:name])
        if ch.save
	    id = Charge.find(:first, :conditions => {:name => params[:name]})
	    params[:charge_values][:charge_id] = id.id
	else
	    flash[:error] = 'Charge name unable to be created. Please choose a name that\'s not already taken.'
	    redirect_to(:action => 'new_row', :id => params[:charge_values][:plan_group_id], :name => params[:gname]) and return
        end
    end
    
    charge = ChargeValue.new(params[:charge_values])
    if charge.save
      flash[:notice] = 'Charge was successfully created.'
      redirect_to :action => 'list', :id => params[:charge_values][:plan_group_id], :name => params[:gname]
    else
      flash[:error] = 'Charge unable to be created. Choose a Plan you have not created a column value for.'
      redirect_to :action => 'new_row', :id => params[:charge_values][:plan_group_id], :name => params[:gname]
    end
  end
  
  def destroy
    ChargeValue.find(params[:id]).destroy
    redirect_to :action => 'list', :id => params[:gid], :name => params[:name]
  end
  
  def show
    @charge = Charge.find(params[:id])
  end

end
