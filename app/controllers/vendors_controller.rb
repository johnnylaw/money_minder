class VendorsController < ApplicationController
  def index
    @outside_entities = Vendor.all
    respond_to do |format|
      format.html {}
      format.json {
        render json: { vendors: @outside_entities.map(&:name) }
      }
    end
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
    @transactions = @outside_entity.purchases.order('executed_at desc')
  end
end