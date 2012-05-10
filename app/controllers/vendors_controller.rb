class VendorsController < ApplicationController
  def index
    @outside_entities = Vendor.all
  end
  
  def new
    @outside_entity = Vendor.new
  end
  
  def create
    @outside_entity = Vendor.new(params[:vendor])
    if @outside_entity.save
      flash[:notice] = "Created vendor '#{@outside_entity.name}'"
      redirect_to customers_path
    else
      flash[:error] = 'Could not save vendor because of errors'
      render 'new'
    end
  end
  
  def show
    @outside_entity = Vendor.find_by_name(params[:name])
    @transactions = @outside_entity.purchases
  end
end