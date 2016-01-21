#coding: utf-8 

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'
require 'mysql2'

client = Mysql2::Client.new(
	:host => "localhost",
	:username => "root",
	:password => "abc123",
	:database => "test",
	:encoding => "utf8"
)

# page = Nokogiri::HTML(open("test.html")) do |config|
# 	config.noblanks.strict.nonet
# end

# rows = page.css("tr")
# rows.each do |row|
# 	tds = row.css("td")
# 	t1 = tds[0].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t2 = tds[1].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t3 = tds[2].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	print t1, "  ", t2, "  ", t3, "\n"
# 	client.query("insert into tb1 values(null, '#{t1}', '#{t2}', '#{t3}', 1);")
# end

# page2 = Nokogiri::HTML(open("test2.html")) do |config|
# 	config.noblanks.strict.nonet
# end

# rows2 = page2.css("tr")
# rows2.each do |row|
# 	tds = row.css("td span")
# 	t1 = tds[0].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t2 = tds[1].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t3 = tds[2].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	print t1, "  ", t2, "  ", t3, "\n"
# 	client.query("insert into tb2 values(null, '#{t1}', '#{t2}', '#{t3}', 1);")
# end

# page3 = Nokogiri::HTML(open("test3.html"), nil, "utf-8") do |config|
# 	config.noblanks.strict.nonet
# end

# rows3 = page3.css("tr")
# rows3.each do |row|
# 	tds = row.css("td span")

# 	t1 = tds[0].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip << tds[1].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t2 = tds[2].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip.to_s.force_encoding("utf-8")
# 	t3 = tds[4].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	print t1, "  ", t2, "  ", t3, "\n"
# 	client.query("insert into tb3 values(null, '#{t1}', '#{t2}', '#{t3}', 3);")
# end

# page4 = Nokogiri::HTML(open("test4.html"), nil, "utf-8") do |config|
# 	config.noblanks.strict.nonet
# end

# rows4 = page4.css("tr")
# rows4.each do |row|
# 	tds = row.css("td")
# 	t1 = tds[0].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t2 = tds[1].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	t3 = tds[2].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
# 	print t1, "  ", t2, "  ", t3, "\n"
# 	client.query("insert into tb4 values(null, '#{t1}', '#{t2}', '#{t3}', 4);")
# end

page5 = Nokogiri::HTML(open("test5.html"), nil, "utf-8") do |config|
	config.noblanks.strict.nonet
end

rows5 = page5.css("tr")
rows5.each do |row|
	tds = row.css("td")
	t1 = tds[0].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
	t2 = tds[1].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
	t3 = tds[2].text.to_s.gsub(/(\&nbsp;)|(\s)/, "").strip
	print t1, "  ", t2, "  ", t3, "\n"
	client.query("insert into tb5 values(null, '#{t1}', '#{t2}', '#{t3}', 4);")
end