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
      p notice_img[0]["src"] if !notice_img.empty? 
      # p notice_img[0]["src"]
      # notice_utf8 = notice.to_html.to_s.encode('UTF-8', 'EUC-KR')
      # return notice.css("b").to_html.to_s.encode('UTF-8', 'EUC-KR')
      # return notice.css("img").to_html.to_s.encode('UTF-8', 'EUC-KR')
      return notice.css("b").text
    end

    def get_view_radio
      # doc = Nokogiri::HTML(open("http://radio.sbs.co.kr/ten"))
      # src = doc.css("frame")[1]["src"]
      # iframe_doc = Nokogiri::HTML(open(src), nil, 'euc-kr')

      iframe_doc = Nokogiri::HTML(File.read("sample.html"))
      # p iframe_doc.css("dl[class=cn]")[1]
      html = iframe_doc.css("div[class=wizLeft] li").to_html.gsub(/\n|\r|\t|   */, '')
      File.write('./view.html', html) # .gsub(/\r\n|\t/, '').strip
      return html
    end

    def get_view_radio_hash(html)
      result = []
      view_radio_doc = Nokogiri::HTML(html)

      h = { "일요일"=> 0 , '월요일' => 1, "화요일" => 2,
        "수요일" => 3,  "목요일" => 4, "금요일" => 5,
        "토요일" => 6 }

      view_radio_doc.css('li').each { |doc|
        desc = doc.css('dt a').text + ' ' + doc.css('dd[class=guest] a').text
        weekday_kor = doc.css('span[class=wk] img')[0]['alt']
        weekday = h[weekday_kor]
        view_yn = doc.css('img[alt=보라]').empty? ? 'N' : 'Y'

        hash = { weekday: weekday,
                 weekday_kor: weekday_kor,
                 desc: desc,
                 view_yn: view_yn }

        result.push(hash)
      }
      result
    end
  end
end