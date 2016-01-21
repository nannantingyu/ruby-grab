require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'
require "mysql2"

page = Nokogiri::HTML(open("http://www.jin10.com")) do |config|
	config.noblanks.strict.nonet
end

liduo = []
liduo2 = []
likong = []
likong2 = []
wuyingxiang = []
wuyingxiang2 = []

def getInfluence(page, cls)
	arr = []
	table = page.css("table div[@class='trend "+cls+"']")
	table.each do |tb|
		path = tb.path
		path = path[0, path.rindex("table") + 5]
		tblikong2 = page.xpath(path)
		tds = tblikong2.css("td")
		arr.push(tds[2].text.to_s.strip)
	end

	return arr
end

liduo = getInfluence(page, "liduo")
liduo2 = getInfluence(page, "liduo2")
likong = getInfluence(page, "likong")
likong2 = getInfluence(page, "likong2")
wuyingxiang = getInfluence(page, "wuyingxiang")
wuyingxiang2 = getInfluence(page, "wuyingxiang2")


a = ["a", "b"]
puts a.index("c") != nil






