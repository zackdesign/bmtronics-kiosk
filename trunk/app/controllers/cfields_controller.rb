class CfieldsController < ApplicationController

  def index
    modify
    render :action => 'modify'
  end
  
  def modify
    @fields = ChargeType.ChargeTypeFields.find(params[:id])
  end

end