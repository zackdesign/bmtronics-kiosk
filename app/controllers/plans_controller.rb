class PlansController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @plan_pages, @plans = paginate :plans, :per_page => 10
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
    @phones = Phone.find(:all)
  end

  def create
    @plan = Plan.Phones.new(params[:plan, :phone])
    if @plan.save
      flash[:notice] = 'Plan was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @plan = Plan.find(params[:id])
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
