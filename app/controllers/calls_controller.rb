class CallsController < ApplicationController
  include Plivo
  layout "print", only: :print
  before_action :set_call, only: [:show, :edit, :update, :destroy]

  # skip the authorization so we can receive posts from twilio
  skip_before_action :authorize, :current_user


  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.call_records(agent_id: current_user.id)
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
  end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit
  end


  # POST /calls
  # POST /calls.json
  # Retrieve and execute the TwiML at this URL via the selected HTTP method when this application receives a phone call.
  def create
    @call = Call.new(call_params)

    respond_to do |format|
      if @call.save
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
        format.json { render action: 'show', status: :created, location: @call }
      else
        format.html { render action: 'new' }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  # Make a request to this URL when a call to this application is completed.
  def update

    @call = Call.find(call_params[:parent_call_uuid])
    @call.call_status= params[:call_status]
    @call.duration = params[:call_duration]
    @call.price = params[:total_rate]

    respond_to do |format|
      if @call.save
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url }
      format.json { head :no_content }
    end
  end

  def print
    @call = Call.find(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_call
    @call = Call.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def call_params
    params.require(:call).permit(:call_uuid, :parent_call_uuid, :call_duration, :total_amount, :call_direction, :to_number, :from_number, :total_rate, :resource_uri, :end_time)
  end


end
