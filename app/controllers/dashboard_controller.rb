class DashboardController < ApplicationController

  def index
    @receipt = Receipt.new
    @active_calls = Call.call_records.where("call_status IN (?) AND created_at >= ? and  created_at <= ? AND agent_id=?", Call::ACTIVE_CALL_STATUS, Date.today.beginning_of_day, Date.today.end_of_day, current_user.id).order("created_at desc").limit(10)
    @today_calls = Call.call_records.where("call_status IN (?) AND created_at >= ? and  created_at <= ? AND agent_id=?", Call::COMPLETED_CALL_STATUS, Date.today.beginning_of_day, Date.today.end_of_day, current_user.id).order("created_at desc").limit(10)
  end


end
