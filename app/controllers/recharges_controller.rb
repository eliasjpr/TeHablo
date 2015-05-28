class RechargesController < ApplicationController
  before_action :set_recharge, only: [:show, :edit, :update, :destroy]

  # GET /recharges
  # GET /recharges.json
  def index
    @recharges = Recharge.where(:user_id => current_user.id).order('created_at DESC')
  end

  # GET /recharges/1
  # GET /recharges/1.json
  def show
  end

  # GET /recharges/new
  def new
    @recharge = Recharge.new
  end

  # GET /recharges/1/edit
  def edit
  end


  # POST /recharges
  # POST /recharges.json
  def create

    @recharge = Recharge.recharge_by_credit_card(user: current_user, recharge: recharge_params)

    respond_to do |format|
      if @recharge.save

        # create recharge
        receipt = Receipt.create({user_id: @recharge.user.id, agent_id: @recharge.agent.id, amount: @recharge.amount, ip_address: request.remote_ip})
        receipt.save

        format.html { redirect_to @recharge, notice: 'Recharge was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /recharges/1
  # PATCH/PUT /recharges/1.json
  def update
    respond_to do |format|
      if @recharge.update(recharge_params)
        format.html { redirect_to @recharge, notice: 'Recharge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recharge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recharges/1
  # DELETE /recharges/1.json
  def destroy
    @recharge.destroy
    respond_to do |format|
      format.html { redirect_to recharges_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recharge
    @recharge = Recharge.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recharge_params
    params.require(:recharge).permit(:user_id, :agent_id, :last4, :card_type, :paid, :amount, :currency, :refunded, :fee, :captured, :failure_message, :failure_code, :amount_refunded, :customer, :invoice, :description, :dispute, :number, :card_name, :exp_month, :exp_year, :cvc)
  end


end
