class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  skip_before_action :authorize,  only: [:money_transfer_webhook]

  # GET /receipts
  def index
    if current_user.is_agent? || current_user.is_super_agent?
      @receipts = Receipt.all.where(agent_id: current_user.id).order('created_at DESC')
    else
      @receipts = Receipt.all.where(agent_id: current_user.id).order('created_at DESC')
    end
  end

  # GET /receipts/1
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end


  def quick_recharge
    @receipt = Receipt.new
    @receipt.amount = receipt_params[:amount]
    @receipt.ip_address = request.remote_ip
    @receipt.agent_id = current_user.id

    calling_id = CallingId.where("call_id=?", quick_recharge_params[:call_id]).take
    @receipt.user = calling_id.user unless calling_id.nil?

    if @receipt.save

      redirect_to @receipt, notice: 'Receipt was successfully created.'
    else

      redirect_to dashboard_index_path, alert: 'Phone number not found!'
    end
  end


  # POST /receipts
  def create
    @receipt = Receipt.new(receipt_params)
    @receipt.ip_address = request.remote_ip
    @receipt.agent_id = current_user.id

    # If we are recharging by calling id
    if @receipt.save

      redirect_to @receipt, notice: 'Receipt was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /receipts/1
  def update
    if @receipt.update(receipt_params)
      redirect_to @receipt, notice: 'Receipt was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /receipts/1
  def destroy
    @receipt.destroy
    redirect_to receipts_url, notice: 'Receipt was successfully destroyed.'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def receipt_params
    params.require(:receipt).permit(:user_id, :agent_id, :amount, :commission_earned, :commission_rate, :ip_address)
  end

  def quick_recharge_params
    params.permit(:call_id)
  end
end
