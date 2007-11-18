class CfieldsController < ApplicationController

  def index
    modify
    render :action => 'modify'
  end
  
  def modify
    @fields = ChargeRow.find(:all,
    :select => "
    charge_rows.id as rid, 
    charge_rows.name as rname,
    charge_rows.value as rvalue,
    charge_columns.id as cid, 
    charge_columns.charge_row_id as crid,
    charge_columns.value as cvalue,
    charge_columns.name as cname",
    :conditions => ["charges_id = ?", params[:id]],
    :joins => "JOIN charge_columns ON charge_rows.id = charge_columns.charge_row_id",
    :order =>"charge_rows.name ASC")

    @field_counts = ChargeRow.find(:all,
    :select => "COUNT(*) as count",
    :conditions => ["charges_id = ?", params[:id]],
    :joins => "JOIN charge_columns ON charge_rows.id = charge_columns.charge_row_id",
    :order =>"charge_rows.name ASC",
    :group => "charge_rows.name")

    @name = params[:name]
  end
  
  def newc
#    @charge_row_id = params[:id]
    @charge_id = params[:id]
    @charge_rows = ChargeRow.find_all_by_charges_id(params[:id])
    @charge_col = ChargeColumn.new
    @charge_col_id = ''
  end
  
  def createc
    @charge_col = ChargeColumn.new(params[:charge_col])
    if @charge_col.save
      flash[:notice] = 'Plan Charge Column was successfully created.'
      redirect_to :action => 'modify', :id => params[:id], :name => Charge.find(params[:id]).name
    else
    end
  end
  
  def newr
    @charge_id = params[:id]
#    @charge_name = params[:name]
    @charge_row = ChargeRow.new
#    @charge_row.charges_id = @charge_id
    @charge_row_id = ''
  end
  
  def creater
    @charge_row = ChargeRow.new(params[:charge_row])
    if @charge_row.save
      @charge_col = ChargeColumn.new
      @charge_col.charge_row_id = @charge_row.id #params[:charge_row]
      @charge_col.name = "Edit This (New Column Name)"
      @charge_col.value = "Edit This (New Column Value)"
      if @charge_col.save
        flash[:notice] = 'Plan Charge Row was successfully created.'
#        params[:name] = Charge.find(params[:id]).name
        redirect_to :action => 'modify', :id => params[:id], :name => Charge.find(params[:id]).name
      else
        flash[:notice] = 'Unable to create new Plan Charge Row since unable to create default Column.'
        @charge_row.destroy @charge_row.id
        render :action => 'newr'
      end
    else
      @charge_id = params[:id]
      @charge_row_id = ''
      render :action => 'newr'
    end
  end
  
  def editc
    @charge_col_id = params[:id]
#    @charge_id = params[:id]
    @charge_col = ChargeColumn.find(@charge_col_id)
    @charge_id = ChargeRow.find(@charge_col.charge_row_id).charges_id
    @charge_rows = ChargeRow.find_all_by_charges_id(@charge_id)
  end
  
  def updatec
    @charge_col_id = params[:charge_col_id]
    @charge_col = ChargeColumn.find(@charge_col_id)
    @charge_id = params[:id]
    if @charge_col.update_attributes(params[:charge_col])
      flash[:notice] = 'Plan Charge Column was successfully updated.'
      redirect_to :action => 'modify', :id => @charge_id, :name => Charge.find(@charge_id).name
    else
      render :action => 'editc'
    end
  end
  
  def editr
    @charge_row_id = params[:id]
#    @charge_name = params[:name]
    @charge_row = ChargeRow.find(@charge_row_id)
#    @charge_row.charges_id = @charge_id
#    @charge_id = @charge_row_id
    @charge_id = @charge_row.charges_id
  end
  
  def updater
    @charge_row_id = params[:charge_row_id]
    @charge_row = ChargeRow.find(@charge_row_id)
    @charge_id = params[:id]
    if @charge_row.update_attributes(params[:charge_row])
      flash[:notice] = 'Plan Charge Row was successfully updated.'
      redirect_to :action => 'modify', :id => @charge_id, :name => Charge.find(@charge_id).name
    else
      render :action => 'editr'
    end
  end
  
  def destroyc
    @charge_col = ChargeColumn.find(params[:id])
    @charge_row = ChargeRow.find(@charge_col.charge_row_id)
    @charge_id = @charge_row.charges_id
    @charge_name = Charge.find(@charge_id).name

    @charge_col.destroy
    unless @charge_row.charge_columns.length > 0
      @charge_row.destroy
    end
    redirect_to :action => 'modify', :id => @charge_id, :name => @charge_name
  end
  
  def destroyr
    @charge_row = ChargeRow.find(params[:id])
    @charge_id = @charge_row.charges_id
    @charge_name = Charge.find(@charge_id).name
    for col in @charge_row.charge_columns
      col.destroy
    end
    @charge_row.destroy
    redirect_to :action => 'modify', :id => @charge_id, :name => @charge_name
  end

end
