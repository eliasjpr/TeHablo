class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = current_user.customers.order('created_at DESC')
  end

  # GET /users/1
  # GET /users/1.json
  def show
    (@user.is_customer?) ? @endpoint = plivo.get_endpoint({"endpoint_id" => @user.agent.endpoint_id})[1] : @endpoint = plivo.get_endpoint({"endpoint_id" => @user.endpoint_id})[1]
    @receipts = @user.receipts
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.parent_id = current_user.id

    # If the logged in user is an agent
    if current_user.is_agent?
      # Set the role customer for the account being created
      @user.roles = User::ROLES[1]
    end

    respond_to do |format|
      if @user.save
        p receipt_params[:receipt].nil?
        unless receipt_params[:receipt].nil?
          receipt= Receipt.create({user_id: @user.id, amount: receipt_params[:receipt], agent_id: @user.agent.id, ip_address: request.remote_ip})
          receipt.save();
        end

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :logo, :business_name, :balance, :commission, :account_status, :sid, :auth_token, :roles, :bank_account, :routing_number, :account_number, :tax_id)
  end

  def receipt_params
    params.permit(:receipt)
  end
end
