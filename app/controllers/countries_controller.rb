class CountriesController < ApplicationController

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      redirect_to countries_path
    else
      render "countries/new"
    end
  end

  def edit
     @country = Country.find_by(id: params[:id])
  end

  def update
     @country = Country.find_by(id: params[:id])
  end

  def show
    @country = Country.find_by(id: params[:id])
  end

  def index
    @countries = Country.all
  end

  def destroy
    Country.find(params[:id]).destroy
    redirect_to countries_path
  end

  private

  def country_params
    params.require(:country).permit(:name)
  end
end
