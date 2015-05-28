class RatesController < ApplicationController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

  # GET /rates
  # GET /rates.json
  def index
    @rates = Rate.all
  end

  # GET /rates/1
  # GET /rates/1.json
  def show
  end

  # GET /rates/1
  # GET /rates/1.json
  def check_rates
    @countries = Rate.select("country_iso, country").distinct("country_iso").order("country asc")

    unless find_params[:from].nil? && find_params[:to].nil?
      @inbound = Rate.where("direction=? and country_iso=?", "inbound", find_params[:from]).take
      @outbound = Rate.where("direction=? and country_iso=?", "outbound", find_params[:to]).take
      @number_rent = Rate.where("direction=? and country_iso=?", "inbound", find_params[:to]).take

      @voice_rates = ((@inbound.voice_rate + @outbound.voice_rate) * Rate::TEHABLO_RATE_MULTIPLIER)
      @phone_rate  = ((@number_rent.rent_per_number) * Rate::TEHABLO_RATE_MULTIPLIER)
    end

  end


  # GET /rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /rates
  # POST /rates.json
  def create
    @rate = Rate.new(rate_params)

    respond_to do |format|
      if @rate.save
        format.html { redirect_to @rate, notice: 'Rate was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rate }
      else
        format.html { render action: 'new' }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rates/1
  # PATCH/PUT /rates/1.json
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to @rate, notice: 'Rate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1
  # DELETE /rates/1.json
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to rates_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rate
    @rate = Rate.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rate_params
    params.require(:rate).permit(:direction, :country, :country_code, :country_iso, :prefix, :voice_rate, :unit_in_seconds, :number_type, :rent_per_number, :setup_cost_per_number)
  end

  def find_params
    params.permit(:from, :to)
  end
end
