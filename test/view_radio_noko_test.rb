
require 'open-uri'
require 'nokogiri'
require 'json'

docJson = JSON.parse(open("https://static.apis.sbs.co.kr/program-api/2.0/main/ten").read)

weeks = nil
for doc in docJson["layers"]
    if doc["layer"] == "weekly"
        weeks = doc["weeks"]
    end
end

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
p result