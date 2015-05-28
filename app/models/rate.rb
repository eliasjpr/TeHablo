class Rate < ActiveRecord::Base

  TEHABLO_RATE_MULTIPLIER = 1.75

  def self.get_rate(outbound_number, inbound_number)

    if inbound_number.nil? || outbound_number.nil?
     return 0.09
    end

    if inbound_number[0, 4] == "sip:" && outbound_number[0, 4] == "sip:"

      return 0.07 # rate for VOIP sip call

    elsif  inbound_number[0, 4] == "sip:" && outbound_number[0, 4] != "sip:"

      in_number = 0.035
      out_number = Fakie.parse(outbound_number, default_country: 'US')

      if out_number.region_code == "US" || out_number.region_code.nil?
        outbound = where("direction=? and country_iso_2=?", "outbound", out_number.region_code,).take
      else
        prefix = out_number.country_code.to_s + out_number.area_code.to_s
        outbound = where("direction=? and country_iso_2=? and prefix=?", "outbound", out_number.region_code, prefix).take
      end


      return ((in_number) + (outbound.voice_rate.to_f * TEHABLO_RATE_MULTIPLIER))

    elsif  inbound_number[0, 4] != "sip:" && outbound_number[0, 4] == "sip:"

      out_number = 0.035
      in_number = Fakie.parse(inbound_number, default_country: 'US')
      inbound = where("direction=? and country_iso_2=?", "inbound", in_number.region_code).take

      return ((out_number) + (inbound.voice_rate.to_f * TEHABLO_RATE_MULTIPLIER))

    else

      in_number   = Fakie.parse(inbound_number, default_country: 'US')
      out_number  = Fakie.parse(outbound_number, default_country: 'US')
      in_prefix   = in_number.country_code.to_s + out_number.area_code.to_s
      out_prefix  = out_number.country_code.to_s + out_number.area_code.to_s

      inbound = where("direction=? and country_iso_2=?", "inbound", in_number.region_code).take


      if out_number.region_code == 'US' || out_number.region_code.nil?
        outbound = where("direction=? and country_iso_2=?", "outbound", 'US').take
      else
        outbound = where("direction=? and country_iso_2=? and prefix=?", "outbound", out_number.region_code, out_prefix).take
      end

      return ((outbound.voice_rate.to_f * TEHABLO_RATE_MULTIPLIER) + (inbound.voice_rate.to_f * TEHABLO_RATE_MULTIPLIER))

    end

  end


  def self.calculate_time_limit(outbound_number, inbound_number, balance)
    if inbound_number[0, 4] == "sip:"
      # Devide by 60 to get time limit in seconds
      ((balance / get_rate(outbound_number, inbound_number)) * 60).to_i # rate for VOIP sip call
    else
      ((balance / get_rate(outbound_number, inbound_number)) * 60).to_i
    end
  end

end
