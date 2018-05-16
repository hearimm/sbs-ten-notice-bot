require 'date'

# Date From String
module DateFromStr
  class << self
    @time = nil
    @date = nil

    def get_time(date, time)
      y = Time.now.year
      m = date.split('/')[0].to_i
      d = date.split('/')[1].to_i
      hh = time.split(':')[0].to_i
      mm = time.split(':')[1].to_i
      y += 1 if m < Time.now.month

      Time.new(y, m, d, hh, mm, 0, '+09:00')
    end

    def get_hash_list(str)
      @result = []
      str.each_line() { |s|
        @time = getTimeStr(s) if hasTime(s)
        @date = getDateStr(s) if hasDate(s)
        @result.push({ time: get_time(@date, @time),
          desc: s.strip,
          date: Time.now }) if (hasTime(s) || hasDate(s)) && get_time(@date, @time) > Time.now
      }

      @result
    end

    private

    def hasDate(str)
      a = str.match?(/((?:[1-2][0-9]|[0-9]|)\/(?:[0-3][0-9]|[0-9]))/)
      if a.nil?
        a = false
      end
      return a
    end

    def hasTime(str)
      a = str.match?(/((?:0[0-9]|1[0-9]|2[0-3])+:[0-5][0-9])/)
      if a.nil?
        a = false
      end
      return a
    end

    def getDateStr(str)
      a = str.scan(/((?:[1-2][0-9]|[0-9]|)\/(?:[0-3][0-9]|[0-9]))/)
      if !a.empty?
        return a[0][0]
      else
        return nil
      end
    end

    def getTimeStr(str)
      a = str.scan(/((?:0[0-9]|1[0-9]|2[0-3])+:[0-5][0-9])/)
      if !a.empty?
        return a[0][0]
      else
        return nil
      end
    end
  end
end