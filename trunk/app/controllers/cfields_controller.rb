class CfieldsController < ApplicationController

  def index
    modify
    render :action => 'modify'
  end
  
  def modify

    @field_counts = ChargeRow.find(:all,
    :select => "COUNT(*) as count",
    :conditions => ["charges_id = ?", params[:id]],
    :joins => "JOIN charge_columns ON charge_columns.id = charge_rows.charge_column_id",
    :order =>"charge_columns.name ASC",
    :group => "charge_columns.name")

    @name = params[:name]
  end
  
  def newr
    @charge_id = params[:id]
    @charge_columns = ChargeColumn.find_all_by_charges_id(params[:id])
    @charge_col = ChargeRow.new
    @charge_col_id = ''
  end
  
  def creater
    @charge_col = ChargeRow.new(params[:charge_row])
    if @charge_col.save
      flash[:notice] = 'Plan Charge Row was successfully created.'
      redirect_to :action => 'modify', :id => params[:id], :name => Charge.find(params[:id]).name
    else
    end
  end
  
  def newc
    @charge_id = params[:id]
#    @charge_name = params[:name]
    @charge_row = ChargeRow.new
#    @charge_row.charges_id = @charge_id
    @charge_row_id = ''
  end
  
  def createc
    @charge_row = ChargeColumn.new(params[:charge_col])
    if @charge_row.save
      @charge_col = ChargeRow.new
      @charge_col.charge_column_id = @charge_row.id
      @charge_col.name = "Edit This (New Row Name)"
      @charge_col.value = "Edit This (New Row Value)"
      if @charge_col.save
        flash[:notice] = 'Plan Charge Column was successfully created.'
        redirect_to :action => 'modify', :id => params[:id], :name => Charge.find(params[:id]).name
      else
        flash[:notice] = 'Unable to create new Plan Charge Row since unable to create default Row.'
        @charge_row.destroy @charge_row.id
        render :action => 'newr'
      end
    else
      @charge_id = params[:id]
      @charge_row_id = ''
      render :action => 'newr'
    end
  end
  
  def editr
    @charge_row_id = params[:id]
    @charge_row = ChargeRow.find(@charge_row_id)
    @charge_id = ChargeColumn.find(@charge_row.charge_column_id).charges_id
    @charge_columns = ChargeColumn.find_all_by_charges_id(@charge_id)
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
  
  def editc
    @charge_col_id = params[:id]
    @charge_col = ChargeColumn.find(@charge_col_id)
    @charge_id = @charge_col.charges_id
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
    @charge_id = @charge_col.charges_id
    @charge_name = Charge.find(@charge_id).name

    @charge_col.destroy
    redirect_to :action => 'modify', :id => @charge_id, :name => @charge_name
  end
  
  def destroyr
    @charge_row = ChargeRow.find(params[:id])
    @chargec_id = @charge_row.charge_column_id
    @charge_id = ChargeColumn.find(@chargec_id)
    @charge_name = Charge.find(@charge_id.charges_id).name
    
    @charge_row.destroy
    redirect_to :action => 'modify', :id => @charge_id.charges_id, :name => @charge_name
  end

end
