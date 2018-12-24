
require 'date'
require 'test/unit'

require 'open-uri'
require 'nokogiri'

def date_of_next(day)
  p date  = Date.parse(day) + 7
  p delta = date > Date.today ? 0 : 7
  date + delta
end

class MyTest < Test::Unit::TestCase
  def test_some
    h = { "일요일"=> 'Sun' , '월요일' => 'Mon', "화요일" => 'Tue',
      "수요일" => 'Wed',  "목요일" =>'Thu', "금요일" => 'Fri',
      "토요일" => 'Sat'}
    a = "월요일 THE 덕 퀴즈쇼 정용국"

    date = ""
    h.each {|k,v|
      date = date_of_next(v) if a.include? k
    }

    m = date.mon
    d = date.mday
    act = Time.new(2018,m,d,22,00,0,'+09:00')
    exp = Time.new(2018,12,31,22,00,0,'+09:00')
    assert_equal(exp,act, 'Assertion was false.')
  end
end

class MyTest < Test::Unit::TestCase
  def test_crawl
    doc = Nokogiri::HTML(open("https://programs.sbs.co.kr/radio/ten"))
      
    notice = doc.css("div[class=mftb_notice_w]")

    p notice

    # notice_img = notice.css("img")
    # p notice_img[0]["src"] if !notice_img.empty?

    # p notice_img[0]["src"]
    # notice_utf8 = notice.to_html.to_s.encode('UTF-8', 'EUC-KR')
    # return notice.css("b").to_html.to_s.encode('UTF-8', 'EUC-KR')
    # return notice.css("img").to_html.to_s.encode('UTF-8', 'EUC-KR')
    act = notice.text
    exp = ""
    assert_equal(exp,act, 'Assertion was false.')
  end
end