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
#    @plan_pages, @plans = paginate :plans, { :per_page => 10, :conditions => 'plan_group IS NOT NULL' }
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
	@options = Option.find(:all, :order => 'name ASC')
	
    # Create the Bonus Option tabs
    @current_letter = ''
    @option_letters = Array.new
    @option_tabs = Array.new
    @tab = Array.new
    @first_time = true

    @options.each { |option|
      if @first_time
        @tab << option
      end

      first_letter = option.name[0,1].upcase
      unless (first_letter == @current_letter)
        @option_letters.push(first_letter)
        @current_letter = first_letter
        unless @first_time
          @option_tabs << @tab
          @tab = Array.new(1, option)
        end
      else
        @tab << option
      end

      if @first_time
        @first_time = false
      end
    }

    unless @tab.empty?
      @option_tabs << @tab
    end
  end

  def newgroup
    @plan_group = PlanGroup.new
    @phones = Phone.find_all
#    @action = 'new'   # This is not what I want - what I want is some way to know what the action is inside the layout
#    @plans = Plan.find_all
    @plans = Plan.find(:all, { :conditions => "plan_group IS NULL" })
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
      flash[:notice] = 'Plan group was successfully created.'
      redirect_to :action => 'listgroups'
    else
      render :action => 'newgroup'
    end
  end

  def edit
    @plan = Plan.find(params[:id])
    @phones = Phone.find_all
	@options = Option.find(:all, :order => 'name ASC')
	
    # Create the Bonus Option tabs
    @current_letter = ''
    @option_letters = Array.new
    @option_tabs = Array.new
    @tab = Array.new
    @first_time = true

    @options.each { |option|
      if @first_time
        @tab << option
      end

      first_letter = option.name[0,1].upcase
      unless (first_letter == @current_letter)
        @option_letters.push(first_letter)
        @current_letter = first_letter
        unless @first_time
          @option_tabs << @tab
          @tab = Array.new(1, option)
        end
      else
        @tab << option
      end

      if @first_time
        @first_time = false
      end
    }

    unless @tab.empty?
      @option_tabs << @tab
    end
  end

  def editgroup
    @plan_group = PlanGroup.find(params[:id])
#    @phones = Phone.find_all
    @plans = Plan.find_all
#    @plans = Plan.find(:all, { :conditions => "plan_group IS NULL" })
  end

  def update
    @plan = Plan.find(params[:id])

#breakpoint

#    if @params[:phone_ids]
#      @plan.phones = Phone.find(@params[:phone_ids]) 
#    else
#      for phone in @plan.phones
#        @plan.remove_phones(phone)
#      end
#    end

#breakpoint

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

  def destroygroup
    PlanGroup.find(params[:id]).destroy
    redirect_to :action => 'listgroups'
  end
end
