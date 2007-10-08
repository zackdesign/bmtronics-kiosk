class OptionsController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @option_pages, @options = paginate :options, :per_page => 10
    @option_pages, @options = paginate :options, { :per_page => 10 }
  end

  def listarch
    @option_pages, @options = paginate :options, { :per_page => 10 }
    render :action => 'list'
  end

  def show
    @option = Option.find(params[:id])
  end

  def new
    @option = Option.new
    @plans = Plan.find(:all, :order => 'name ASC')
    @current_letter = ''
    @letters = Array.new
    @tabs = Array.new
    @tab = Array.new
    @first_time = true

    @plans.each { |plan|
      if @first_time
        @tab << plan
      end

      first_letter = plan.name[0,1].upcase
      unless (first_letter == @current_letter)
        @letters.push(first_letter)
        @current_letter = first_letter
        unless @first_time
          @tabs << @tab
          @tab = Array.new(1, plan)
        end
      else
        @tab << plan
      end

      if @first_time
        @first_time = false
      end
    }

    unless @tab.empty?
      @tabs << @tab
    end
  end

  def create
    @option = Option.new(params[:option])
    if @option.save
      flash[:notice] = 'option was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @option = Option.find(params[:id])
    @plans = Plan.find(:all, :order => 'name ASC')
    @current_letter = ''
    @letters = Array.new
    @tabs = Array.new
    @tab = Array.new
    @first_time = true

    @plans.each { |plan|
      if @first_time
        @tab << plan
      end

      first_letter = plan.name[0,1].upcase
      unless (first_letter == @current_letter)
        @letters.push(first_letter)
        @current_letter = first_letter
        unless @first_time
          @tabs << @tab
          @tab = Array.new(1, plan)
        end
      else
        @tab << plan
      end

      if @first_time
        @first_time = false
      end
    }

    unless @tab.empty?
      @tabs << @tab
    end
  end

  def update
    @option = Option.find(params[:id])
    if @option.update_attributes(params[:option])
      flash[:notice] = 'option was successfully updated.'
      redirect_to :action => 'show', :id => @option
    else
      render :action => 'edit'
    end
  end

  def delete
    @option = Option.find(params[:id])
    @destroyed = @option.destroy
    redirect_to :action => 'list'
  end

  def deletearch
    @option = Option.find(params[:id])
    @destroyed = @option.destroy
    redirect_to :action => 'listarch'
  end

  def archive
    @option = Option.find(params[:id])
    if @option.update_attribute(:active, false)
      flash[:notice] = 'option was successfully archived.'
    else
      flash[:notice] = 'option could not be archived.'
    end
    redirect_to :action => 'list'
  end

  def unarchive
    @option = Option.find(params[:id])
    if @option.update_attribute(:active, true)
      flash[:notice] = 'option was successfully unarchived.'
    else
      flash[:notice] = 'option could not be unarchived.'
    end
    redirect_to :action => 'listarch'
  end
end
