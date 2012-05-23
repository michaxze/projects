module MapsHelper

  def formatted_time(time)
    time_formatted = ""

    unless time.blank?
      time_mil =  time.gsub(":", "")
      time_int = "%04d" % time_mil.to_i
      time_int = time_int.to_i
      if time_int >= 1300
        hours = time_int - 1200
        hour = hours.to_s[0..-3]
        min = hours.to_s[1..-1]
        hour = hour.to_i > 0 ? hour : 12
        ampm = "pm"
        time_formatted = "#{hour.to_i}:#{min}#{ampm}"
      else
        hour = time_mil.to_s[0..-3]
        hour = hour.to_i > 0 ? hour : 12
        min = time_mil.to_s[2..-1]
        ampm = time_int > 1200 ? "pm" : "am"
        time_formatted = "#{hour.to_i}:#{min}#{ampm}"
      end
    end

    time_formatted
  end

end
