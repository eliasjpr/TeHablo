class CallingIdsController < ApplicationController
  before_action :set_calling_id, only: [:show, :edit, :update, :destroy]

  # GET /calling_ids
  # GET /calling_ids.json
  def index
    @calling_ids = CallingId.all.order('created_at DESC')
  end

  # GET /calling_ids/1
  # GET /calling_ids/1.json
  def show
  end

  # GET /calling_ids/new
  def new
    @calling_id = CallingId.new
    @calling_id.user_id = params[:user_id] if params[:user_id]
  end

  # GET /calling_ids/1/edit
  def edit
  end

  # POST /calling_ids
  # POST /calling_ids.json
  def create
    @calling_id = CallingId.new(calling_id_params)

    respond_to do |format|
      if @calling_id.save
        if request.xhr?
          format.html { redirect_to @calling_id.user, notice: 'Calling was successfully created.' }
        else
          format.html { redirect_to @calling_id, notice: 'Calling was successfully created.' }
        end

        format.json { render action: 'show', status: :created, location: @calling_id }
      else
        format.html { render action: 'new' }
        format.json { render json: @calling_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calling_ids/1
  # PATCH/PUT /calling_ids/1.json
  def update
    respond_to do |format|
      if @calling_id.update(calling_id_params)
        format.html { redirect_to @calling_id, notice: 'Calling was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @calling_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calling_ids/1
  # DELETE /calling_ids/1.json
  def destroy
    @calling_id.destroy
    respond_to do |format|
      format.html { redirect_to calling_ids_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_calling_id
    @calling_id = CallingId.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def calling_id_params
    params.require(:calling_id).permit(:call_id, :user_id)
  end
end
