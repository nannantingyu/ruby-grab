#coding: utf-8 

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'
require 'mysql2'

page = Nokogiri::HTML(open("http://53kf.91guoxin.com/data/GetUserListJs")) do |config|
	config.noblanks.strict.nonet
end

puts page

trs = page.css('table tr')

trs.each do |tr|
	p = tr.css('td p')
	
	# rregex = /<b>.*<\/b>(.+?)<br>/
	rregex = /<b>&aring;&sect;&#147;&aring;&#144;&#141;&iuml;&frac14;&#154;<\/b>(.+?)<br>/
	name = rregex.match(p.to_s)[1]

	# puts p
	puts name.encode('gb2312')

	# link = tr.css('td p a')[1]
	# puts link
	puts ''
end