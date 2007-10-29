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
    
    @name = params[:name]
  end

end