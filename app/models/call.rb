class Call < ActiveRecord::Base
  include Plivo

  APP_CALLING_IDS = [12016233387, 19142499042, 12036141208]

  ACTIVE_CALL_STATUS = ["ringing", "in-progress"]
  COMPLETED_CALL_STATUS = ["hangup", "completed"]
  DIAL_MUSIC         = 'http://www.tehablo.com/audio/AnnouncementBell.mp3'
  GATHER_URL         = 'http://www.tehablo.com/direct/gather.xml'

  scope :call_records, where("to_number not in (?)", APP_CALLING_IDS)

  @plivo = RestAPI.new('MAZJAZZJRLYTAYYZGWYZ', 'YmFlNTdhNWY2OWMzYWJmMWY2OWYwOGE5NDMxZTYy')

  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :agent, class_name: "User", foreign_key: "agent_id"


  # Instance Methods
  def get_call_cost
    (billed_duration/60) * Rate.get_rate(to_number, from_number)
  end

  # Class methods
  def self.make_direct_call(args: {})

    # Find the user based on his calling id
    # Check if the user can make call
    user = CallingId.where("call_id=?", args[:From]).take.user


    # Add call to the database
    call = Call.new({ call_uuid:      args[:CallUUID],
                      to_number:      args[:To],
                      from_number:    args[:From],
                      call_direction: args[:Direction],
                      total_rate:     args[:BillAmount],
                      call_status:    args[:CallStatus] })

    # Set the agent for this call
    user.agent.nil? ? call.agent_id= user.id : call.agent_id= user.agent.id

    # Set the user for this call
    call.user_id = user.id

    # Check if the user can make the call
    call_permitted = user.can_make_call

    if  call_permitted[:can_call]
      if call.save
        # Create new response
        resp = Response.new()

        # Check destination number is valid
        if not call.to_number
          resp.addSpeak("Sorry, you don't have a valid destination number. Please try again")
          resp.addHangup()
        else

          if call.to_number[0, 4] == "sip:"

            # Get SIP call time limit
            time_limit = Rate.calculate_time_limit(call.to_number, call.from_number, call.user.balance)
            # Play TeHablo Sound
            resp.addPlay(DIAL_MUSIC, { 'loop' => 1 })

            d = resp.addDial({ 'callerName' => args[:CallerName], 'timeLimit' => time_limit, 'timeout' => 15 })

            d.addUser(call.to_number)

          elsif APP_CALLING_IDS.include?(call.to_number.to_i)
            # Play TeHablo Sound
            resp.addPlay(DIAL_MUSIC, { 'loop' => 1 })

            # Enter destination number
            d = resp.addGetDigits({ 'action' => GATHER_URL + "?id=#{call.id}&", 'method' => 'GET', 'timeout' => 60, 'retries' => 2 })

            # Read out balance
            d.addSpeak(calL_permitted[:say])

          else

            # Get the time limit for this call
            time_limit = Rate.calculate_time_limit(call.to_number, call.from_number, call.user.balance)

            # Play TeHablo Sound
            resp.addPlay(DIAL_MUSIC, { 'loop' => 1 })

            # Dial Destination number
            d = resp.addDial({ 'callerId' => call.from_number, 'timeLimit' => time_limit, 'timeout' => 60 })
            d.addNumber(call.to_number)

          end
        end
        # Return the xml
        resp.to_xml()
      end
    else
      # Respond with message
      resp.addSpeak(calL_permitted[:say])
      resp.addHangup()

      # Return the xml
      resp.to_xml()
    end
  end


  def self.hangup_direct_call(args: {})

    request_call = @plivo.get_cdr({ "record_id" => args[:CallUUID] })[1]

    call = Call.where("call_uuid=?", args[:CallUUID]).take
    p request_call
    request_call.each do |prop, value|
      call[prop] = value unless ['to_number', 'direction'].include?(prop) and prop.nil? != nil
    end

    call.save

    user = CallingId.where("call_id=?", args[:From]).take.user
    user.deplete_balance(call.get_call_cost)

    resp = Response.new()
    resp.addSpeak("Thank you for using TeHablo. Good bye!")
    resp.addHangup()
    resp.to_xml()
  end


  def self.gather_digits(args: {})
    call             = Call.find(args[:id])
    call.to_number   = args[:Digits]
    call.from_number = args[:From]
    call.call_direction= 'outbound'
    call.call_status = args[:CallStatus]
    call.save

    time_limit = Rate.calculate_time_limit(call.to_number, call.from_number, call.user.balance)
    puts "=========== TIME LIMITED ==========="


    resp = Response.new()
    resp.addPlay(DIAL_MUSIC, { 'loop' => 1 })

    d = resp.addDial({ 'callerId' => call.from_number, 'timeLimit' => time_limit, 'timeout' => 60000 })

    if call.to_number[0..4] != 'sip:'
      d.addNumber(call.to_number)
    else
      d.addUser(call.to_number)
    end

    resp.to_xml()

  end


end
