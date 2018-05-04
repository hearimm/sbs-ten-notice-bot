require 'open-uri'
require 'nokogiri'

module Crawler
    class << self
        def get_notice
            doc = Nokogiri::HTML(open("http://radio.sbs.co.kr/ten"))
            src = doc.css("frame")[1]["src"]
            iframe_doc = Nokogiri::HTML(open(src), nil, 'euc-kr')

            notice = iframe_doc.css("div[class=r_notice_w]")
            notice_img = notice.css("img")
            p notice_img[0]["src"]
            # notice_utf8 = notice.to_html.to_s.encode('UTF-8', 'EUC-KR')
            # return notice.css("b").to_html.to_s.encode('UTF-8', 'EUC-KR') 
            # return notice.css("img").to_html.to_s.encode('UTF-8', 'EUC-KR') 
            return notice.css("b").text
        end
    end
end