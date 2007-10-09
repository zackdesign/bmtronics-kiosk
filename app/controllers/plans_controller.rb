class PlansController < ApplicationController
    
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

  def show
    @plan = Plan.find(params[:id])
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

  def update
    @plan = Plan.find(params[:id])

    if @plan.update_attributes(params[:plan])
      flash[:notice] = 'Plan was successfully updated.'
      redirect_to :action => 'show', :id => @plan
    else
      render :action => 'edit'
    end
  end

  def destroy
    Plan.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end
