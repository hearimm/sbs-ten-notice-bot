# frozen_string_literal: true

require 'date'

# Date From String
module DateFromStr
  class << self
    @time = nil
    @date = nil
    @time_change = false

    def get_time(date, time)
      return nil if date.nil? || time.nil?

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
      str.each_line do |s|
        @time = getTimeStr(s) if hasTime(s)
        @date = getDateStr(s) if hasDate(s)
        next unless (hasTime(s) && hasDate(s)) && get_time(@date, @time) > Time.now

        @result.push(time: get_time(@date, @time),
                     desc: s.strip,
                     date: Time.now)
      end

      @result
    end

    def get_hash_list_from_plane(str)
      @result = []
      arr = str.split(%r{((?:[1-2][0-9]|[0-9]|)/(?:[0-3][0-9]|[0-9]))|((?:0[0-9]|1[0-9]|2[0-3])+:[0-5][0-9])})
      arr.each do |s|
        if hasTime(s)
          @time = getTimeStr(s)
          @time_change = true
          next
        end

        if hasDate(s)
          @date = getDateStr(s)
          next
        end

        desc = s.strip.delete('　')
        next unless !get_time(@date, @time).nil? && get_time(@date, @time) > Time.now && !desc.empty? && @time_change

        @result.push(time: get_time(@date, @time),
                     desc: desc,
                     date: Time.now)
        @time_change = false
      end

      @result
    end

    private

    def hasDate(str)
      a = str.match?(%r{((?:[1-2][0-9]|[0-9]|)/(?:[0-3][0-9]|[0-9]))})
      a = false if a.nil?
      a
    end

    def hasTime(str)
      a = str.match?(/((?:0[0-9]|1[0-9]|2[0-3])+:[0-5][0-9])/)
      a = false if a.nil?
      a
    end

    def getDateStr(str)
      a = str.scan(%r{((?:[1-2][0-9]|[0-9]|)/(?:[0-3][0-9]|[0-9]))})
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
