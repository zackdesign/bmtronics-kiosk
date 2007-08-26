class PlansController < ApplicationController
  
  layout "main"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @plan_pages, @plans = paginate :plans, :per_page => 10
    @plan_pages, @plans = paginate :plans, { :per_page => 10, :conditions => 'plan_group IS NULL' }
#    for plan in @plans
#      @phones = plan.phones
#      breakpoint
#    end
  end

  def listgroups
    @plan_groups_pages, @plan_groups = paginate :plan_groups, :per_page => 10
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def showgroup
    @plan_group = PlanGroup.find(params[:id])
  end

  def new
    @plan = Plan.new
    @phones = Phone.find_all
#    @action = 'new'   # This is not what I want - what I want is some way to know what the action is inside the layout
  end

  def newgroup
    @plan_group = PlanGroup.new
    @phones = Phone.find_all
#    @action = 'new'   # This is not what I want - what I want is some way to know what the action is inside the layout
  end

  def create
    @plan = Plan.new(params[:plan])
    @plan.phones = Phone.find(@params[:phone_ids]) if @params[:phone_ids]
    if @plan.save
      flash[:notice] = 'Plan was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def creategroup
    @plan = Plan.new(params[:plan])
    @plan.phones = Phone.find(@params[:phone_ids]) if @params[:phone_ids]
    if @plan.save
      flash[:notice] = 'Plan was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @plan = Plan.find(params[:id])
    @phones = Phone.find_all
  end

  def editgroup
    @plan_group = PlanGroup.find(params[:id])
#    @phones = Phone.find_all
  end

  def update
    @plan = Plan.find(params[:id])
    
    if @params[:phone_ids]
      @plan.phones = Phone.find(@params[:phone_ids]) 
    else
      for phone in @plan.phones
        @plan.remove_phones(phone)
      end
    end
         
    if @plan.update_attributes(params[:plan])
      flash[:notice] = 'Plan was successfully updated.'
      redirect_to :action => 'show', :id => @plan
    else
      render :action => 'edit'
    end
  end

  def updategroup
    @plan_group = PlanGroup.find(params[:id])

#    if @params[:phone_ids]
#      @plan.phones = Phone.find(@params[:phone_ids]) 
#    else
#      for phone in @plan.phones
#        @plan.remove_phones(phone)
#      end
#    end

    if @plan_group.update_attributes(params[:plan_group])
      flash[:notice] = 'Plan Group was successfully updated.'
      redirect_to :action => 'showgroup', :id => @plan_group
    else
      render :action => 'editgroup'
    end
  end

  def destroy
    Plan.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
