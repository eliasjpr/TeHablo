class DirectController < ApplicationController
  skip_before_action :authorize

  def make
    # Make a direct call
    xml = Call.make_direct_call(args: direct_params)

    respond_to do |format|
      format.xml { render xml: xml }
    end
  end

  def gather
    # Make a direct call
    xml =  Call.gather_digits(args: direct_params)

    respond_to do |format|
      format.xml { render xml: xml }
    end
  end


  def hangup
    xml = Call.hangup_direct_call(args: direct_params)
    respond_to do |format|
      format.xml { render xml: xml }
    end
  end

  # Zoiper is a SIP softphone privider
  # This method takes a token parameter to search for a user
  # https://oem.zoiper.com
  def register_zoiper
    # Get the user account
    @user = User.find(direct_params[:token])

    # Get the endpoint information
    @endpoint = plivo.get_endpoint({"endpoint_id" => @user.endpoint_id})[1]

    # render the xml with the endpoint information so it can automatically register the SIP account in ZOIPER
    respond_to do |format|
      format.xml
    end
  end

  private

  def direct_params
    params.permit(:To, :From, :CallerName, :CallUUID, :ForwardedFrom, :CallStatus, :Direction, :format, :BillDuration, :ALegRequestUUID, :ALegUUID, :HangupCause, :BillRate, :token, :Digits, :id)
  end
end
