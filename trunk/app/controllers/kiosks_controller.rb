class KiosksController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @kiosks = Kiosk.find(:all)
    @phones = Phone.find(:all)
  end
 

  def submit
    Kiosk.delete_all
if params[:kiosk1]
    params[:kiosk1].each do |key, value|
        kiosk_hash = {"phone_id" => value, 'kiosk' => 1}
       @kiosk = Kiosk.new(kiosk_hash)
       @kiosk.save
    end
end
if params[:kiosk2]
params[:kiosk2].each do |key, value|
        kiosk_hash = {"phone_id" => value, 'kiosk' => 2}
       @kiosk = Kiosk.new(kiosk_hash)
 @kiosk.save
    end
end
if params[:kiosk3]
params[:kiosk3].each do |key, value|
        kiosk_hash = {"phone_id" => value, 'kiosk' => 3}
       @kiosk = Kiosk.new(kiosk_hash)
 @kiosk.save
    end
end
if params[:kiosk4]
params[:kiosk4].each do |key, value|
        kiosk_hash = {"phone_id" => value, 'kiosk' => 4}
       @kiosk = Kiosk.new(kiosk_hash)
 @kiosk.save
    end
end
     redirect_to :action => 'list'
  end

end
