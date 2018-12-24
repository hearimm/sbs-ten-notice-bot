
require 'open-uri'
require 'nokogiri'
require 'json'

docJson = JSON.parse(open("https://static.apis.sbs.co.kr/program-api/2.0/main/ten").read)
# desc = docJson["layers"][5]["description"]

desc = nil
for doc in docJson["layers"]
    if doc["layer"] == "notice"
        desc = doc["description"]
    end
end

# p desc

html_doc = Nokogiri::HTML(desc)
# p html_doc.css("b")

blackList = ["↳[이벤트신청바로가기]", "[베텐인스타그램바로가기]", "└@sbs_ten"]

p html_doc.search('b')
.map{|x| x.text.gsub(/\s+/, "") }
.uniq
.delete_if{|x| x == "" || !blackList.index(x).nil? }
.join("\n")