#coding: utf-8 
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'
require "mysql2"

Interpreter = Struct.new(:title, :nextPubDate, :dataAgent, :frequency, :statistic, :dataEffect, :dataDefinition, :concernReason, :graphData)


#获取解读数据
def getInterprete(dataid)
	pageIndex = Nokogiri::HTML(open("http://rili.jin10.com/jiedu/147337")) do |config|
		config.noblanks.strict.nonet
	end

	regex = /var\s+dataJson\s+=\s+'(.+)';/
	str = regex.match(pageIndex.to_s)

	graphData = JSON.parse(str[1])

	page = pageIndex.css("div[@id='nr']")

	title = page.css("[@class='cjrl_jdtop']").text	#标题
	content = page.css("div[@class='cjrl_jdyh'] ul li")

	tregex = /span>(.*)<\/li>/
	nextPubDate = content[0].css("span")[1].text	#下次公布时间
	dataAgent = tregex.match(content[1].to_s)[1]	#数据公布机构
	frequency = tregex.match(content[2].to_s)[1]	#发布频率
	statistic = tregex.match(content[3].to_s)[1]	#统计方法

	#数据影响中有特殊字符(<, >), 使用正则匹配
	rregex = /\<div class="cjrl_jdnr"\>(.*?)\<\/div\>/

	datas = page.to_s.scan(rregex)
	dataEffect = datas[0]	#数据影响
	dataDefinition = datas[1]	#数据释义
	concernReason = datas[2]	#关注原因

	return Interpreter.new(title, nextPubDate, dataAgent, frequency, statistic, dataEffect, dataDefinition, concernReason, graphData)
end

def htmlSpecial(str)
	return str.gsub(/'/, "''")
end

puts htmlSpecial("agent's hello world")