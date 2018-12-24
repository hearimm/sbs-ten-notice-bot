require 'open-uri'
require 'nokogiri'

module Crawler
  class << self
    def get_notice

      docJson = JSON.parse(open("https://static.apis.sbs.co.kr/program-api/2.0/main/ten").read)
      # desc = docJson["layers"][5]["description"]
      desc = nil
      for doc in docJson["layers"]
          if doc["layer"] == "notice"
              desc = doc["description"]
          end
      end

      if (desc.nil?)
        return ""
      end

      html_doc = Nokogiri::HTML(desc)
      blackList = ["↳[이벤트신청바로가기]", "[베텐인스타그램바로가기]", "└@sbs_ten"]

      return html_doc.search('b')
              .map{|x| x.text.gsub(/\s+/, "") }
              .uniq
              .delete_if{|x| x == "" || !blackList.index(x).nil? }
              .join("\n")
    end

    def get_view_radio
      docJson = JSON.parse(open("https://static.apis.sbs.co.kr/program-api/2.0/main/ten").read)

      weeks = nil
      for doc in docJson["layers"]
          if doc["layer"] == "weekly"
              weeks = doc["weeks"]
          end
      end
      return weeks
    end

    def get_view_radio_hash(weeks)
      result = []

      weeks.each { |week|
          desc = week["items"][0]["title"] + ' ' + week["guest"]
          weekday_kor = week["title"]
          weekday = week["day"]
          view_yn = week["isviewradio"] ? 'Y' : 'N'

          hash = { weekday: weekday,
                      weekday_kor: weekday_kor,
                      desc: desc,
                      view_yn: view_yn }

          result.push(hash)
      }
      return result
    end
  end
end