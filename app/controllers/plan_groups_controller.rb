class PlanGroupsController < ApplicationController
  layout "plans"
  helper :plans
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
           
  def list
    @plan_groups_pages, @plan_groups = paginate :plan_groups, :per_page => 10
  end
  
  def show
    @plan_group = PlanGroup.find(params[:id])
  end
  
  def new
    @plan_group = PlanGroup.new
    @phones = Phone.find_all
    @plans = Plan.find(:all, { :conditions => "plan_group IS NULL" })
  end  
  
  def create
    @plan_group = PlanGroup.new(params[:plan_group])
    @plan_group.phones = Phone.find(@params[:phone_ids]) if @params[:phone_ids]
    if @plan_group.save
      flash[:notice] = 'Plan group was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @plan_group = PlanGroup.find(params[:id])
    @plans = Plan.find_all
  end
  
  def update
    @plan_group = PlanGroup.find(params[:id])

    if @plan_group.update_attributes(params[:plan_group])
      flash[:notice] = 'Plan Group was successfully updated.'
      redirect_to :action => 'show', :id => @plan_group
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    PlanGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end        
end
