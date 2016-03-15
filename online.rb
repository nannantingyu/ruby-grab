#coding: utf-8 

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'
require 'mysql'

# page = Nokogiri::HTML(open("http://53kf.91guoxin.com/data/GetUserListJs")) do |config|
# 	config.noblanks.strict.nonet
# end

# puts page

# trs = page.css('table tr')

# trs.each do |tr|
# 	p = tr.css('td p')
	
# 	# rregex = /<b>.*<\/b>(.+?)<br>/
# 	rregex = /<b>&aring;&sect;&#147;&aring;&#144;&#141;&iuml;&frac14;&#154;<\/b>(.+?)<br>/
# 	name = rregex.match(p.to_s)[1]

# 	# puts p
# 	puts name.encode('gb2312')

# 	# link = tr.css('td p a')[1]
# 	# puts link
# 	puts ''
# end

#连接数据库本机：用户名：root 密码：sa 数据库：makedish 端口：3306  
# def setsql(sql)
# 	db = Mysql.init  
# 	db.options(Mysql::SET_CHARSET_NAME, 'utf8') 
# 	dbh = Mysql.real_connect("192.168.99.199", "root", "123456","cjrl", 3306)
# 	dbh.query("SET NAMES utf8")  
# 	result = dbh.query(sql)
# 	return result
# end

# dataid = '147729'
# sql = 'select * from jb46o_finance_data where dataid = ' + dataid

# result = setsql(sql)

# result.each do |row|
# 	puts row
# end

a = nil
if a != nil
	puts 'bushikong'
else
	puts 'shikongde'
end