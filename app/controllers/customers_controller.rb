class CustomersController < ApplicationController
  def index
    @outside_entities = Customer.all
    render 'vendors/index'
  end
  
  def new
    @outside_entity = Customer.new
    render 'vendors/new'
  end
  
  def create
    @outside_entity = Customer.new(params[:customer])
    if @outside_entity.save
      flash[:notice] = "Created customer '#{@outside_entity.name}'"
      redirect_to customers_path
    else
      flash[:error] = 'Could not save customer because of errors'
      render 'vendors/new'
    end
  end
  
  def show
    @outside_entity = Customer.find_by_name(params[:name])
    @transactions = @outside_entity.revenues
    render 'vendors/show'
  end
end