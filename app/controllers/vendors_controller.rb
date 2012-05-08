class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all
  end
  
  def show
    @vendor = Vendor.find_by_name(params[:name])
  end
end