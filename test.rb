
require 'date'
require 'test/unit'

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
    exp = Time.new(2018,05,07,22,00,0,'+09:00')
    assert_equal(exp,act, 'Assertion was false.')
  end
end