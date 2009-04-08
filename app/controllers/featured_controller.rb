class FeaturedController < ApplicationController
  verify :method => :post, :only => [ :destroy, :create, :update ]
  
  def featured_phones
    @featured = Featured_Phones.find(:all)
    @phones = Phone.find(:all, :order=> "name ASC", :conditions => 'outofstock = 0 AND discontinued = 0')
    render :layout => 'featured_phones'
  end
  
  def submit_phones
    Featured_Phones.delete_all
    if params[:featured]
      params[:featured].each do |key, value|
        kiosk_hash = {"phone_id" => value}
       @phones = Featured_Phones.new(kiosk_hash)
       @phones.save
      end
    end
    redirect_to :action => 'featured_phones'
  end
  
  def featured_accessories
    @featured = Featured_Accessories.find(:all)
    @accessories = Accessory.find(:all, :order=> "name ASC", :conditions => 'outofstock = 0 AND discontinued = 0')
    render :layout => 'featured_accessories'
  end
  
  def submit_accessories
    Featured_Accessories.delete_all
    if params[:featured]
      params[:featured].each do |key, value|
        kiosk_hash = {"accessory_id" => value, "atype" => "featured"}
        @phones = Featured_Accessories.new(kiosk_hash)
      @phones.save
      end
    end
    if params[:latest]
      params[:latest].each do |key, value|
        kiosk_hash = {"accessory_id" => value, "atype" => "latest"}
        @phones = Featured_Accessories.new(kiosk_hash)
      @phones.save
      end
    end
    redirect_to :action => 'featured_accessories'
  end
end
