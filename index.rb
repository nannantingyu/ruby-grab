#coding: utf-8 
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'json'
require "mysql2"

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

#获取日历页数据
PAGE_URL = "http://rili.jin10.com/index.php"

FinanceData     = Struct.new(:time, :region, :quota, :weight, :former_value, :predict_value, :public_value, :interprete)
FinanceEvent    = Struct.new(:time, :region, :city, :weight, :event)
MarketHoliday   = Struct.new(:time, :region, :market, :holiday, :plan)
Interpreter = Struct.new(:title, :nextPubDate, :dataAgent, :frequency, :statistic, :dataEffect, :dataDefinition, :concernReason)

#连接数据库本机：用户名：root 密码：sa 数据库：makedish 端口：3306  
def setsql(sql)
	client = Mysql2::Client.new(
		:host => "localhost",
		:username => "root",
		:password => "abc123",
		:database => "91jin",
		:encoding => "utf8"
	)

	return client.query(sql);
end
 
def crawler(start)

	#获取首页的影响
	pageIndex = Nokogiri::HTML(open("http://www.jin10.com")) do |config|
		config.noblanks.strict.nonet
	end

	liduo = getInfluence(pageIndex, "liduo")
	liduo2 = getInfluence(pageIndex, "liduo2")
	likong = getInfluence(pageIndex, "likong")
	likong2 = getInfluence(pageIndex, "likong2")
	wuyingxiang = getInfluence(pageIndex, "wuyingxiang")
	wuyingxiang2 = getInfluence(pageIndex, "wuyingxiang2")

	url = PAGE_URL+"?date="+start.strftime("%Y%m%d")

	page = Nokogiri::HTML(open(url)) do |config|
		config.noblanks.strict.nonet
	end

	tables = page.css("tbody")

	if tables.length == 3
		f_data_seg  = tables[0]
		f_event_seg = tables[1]
		f_rest_seg  = tables[2]

		# puts "获取财经数据..."
		rows = f_data_seg.css("tr")
		length = rows.length-1
		pre_time = ''
		pre_region = ''

		if length>1
			setsql('DELETE FROM jb46o_finance_data where date="'+start.strftime("%Y%m%d")+'"')
			for i in 0..length do
				colums = rows[i].css("td")
				rs = colums[0]['rowspan']
				if rs.to_i.to_s == rs
					pre_time = colums[0].text
					pre_region = colums[1].css("img")[0]['src']
					f_data = FinanceData.new(pre_time, pre_region, colums[2].text, colums[3].css("img")[0]['src'], colums[4].text, colums[5].text, colums[6].text, colums[7].css("a")[0]['href'])
				else
					f_data = FinanceData.new(pre_time, pre_region, colums[0].text, colums[1].css("img")[0]['src'], colums[2].text, colums[3].text, colums[4].text, colums[5].css("a")[0]['href'])
				end

				title = f_data.quota.gsub(/\s/, "")
				#根据指标名称获取影响
				influence = ""
				if liduo.index(title) != nil
					influence = "liduo"
				elsif liduo2.index(title) != nil
					influence = "liduo2"
				elsif likong.index(title) != nil
					influence = "likong"
				elsif likong2.index(title) != nil
					influence = "likong2"
				elsif wuyingxiang.index(title) != nil
					influence = "wuyingxiang"
				elsif wuyingxiang2.index(title) != nil
					influence = "wuyingxiang2"
				end

				params = getParam(f_data.interprete)

				# setsql("delete from jb46o_interpreter where dataid=" + params["dataid"] + " and datanameid=" + params["datanameid"])
				if checkExits(Hash["datanameid"=>params["datanameid"], "dataid"=>params["dataid"]], "jb46o_finance_data") < 1
					#插入经济数据
					setsql("insert into jb46o_finance_data values(null,'"+start.strftime("%Y%m%d")+"','"+f_data.time+"','"+f_data.region+"','"+f_data.quota+"','"+f_data.weight+"','"+f_data.former_value+"','"+f_data.predict_value+"','"+f_data.public_value+"','"+influence+"',"+params["datanameid"]+","+params["dataid"]+")")
				else
					#更新经济数据
					setsql("update jb46o_finance_data set time='#{f_data.time}', region='#{f_data.region}', quota='#{f_data.quota}',weight='#{f_data.weight}',former_value='#{f_data.former_value}',predict_value='#{f_data.predict_value}',public_value='#{f_data.public_value}',influence='#{influence}' where datanameid=#{params['datanameid']} and dataid=#{params['dataid']};")
				end

				#插入解读
				interpreter = getInterprete params["dataid"]
				# puts interpreter.dataDefinition
				if checkExits(Hash["datanameid"=>params["datanameid"], "dataid"=>params["dataid"]], "jb46o_interpreter") < 1
					setsql("insert into jb46o_interpreter values(null, " + params["datanameid"] + "," + params["dataid"] + ",'" + interpreter.title + "','" + interpreter.nextPubDate + "','" + interpreter.dataAgent + "','" + interpreter.frequency + "','" + interpreter.statistic + "','" + interpreter.dataEffect + "','" + interpreter.dataDefinition + "','" + interpreter.concernReason + "','" + getGraphDatas(params["datanameid"]) + "');")
				else
					setsql("update jb46o_interpreter set title='#{interpreter.title}', nextPubDate='#{interpreter.nextPubDate}', dataAgent='#{interpreter.dataAgent}', frequency='#{interpreter.frequency}', statistic='#{interpreter.statistic}', dataeffect='#{interpreter.dataEffect}', datadefinition='#{interpreter.dataDefinition}', concernreason='#{interpreter.concernReason}', graphdata='#{getGraphDatas(params["datanameid"])}' where datanameid=#{params['datanameid']} and dataid=#{params['dataid']};")
				end
			end
		end

		# puts "获取财经事件..."
		rows =  f_event_seg.css("tr")

		setsql('DELETE FROM jb46o_finance_event where date="'+start.strftime("%Y%m%d")+'"')
		rows.each do | row |
			colums = row.css("td")
			rs = colums[0]['colspan']
			if rs.to_i.to_s != rs #排除没有的情况
				f_event = FinanceEvent.new(colums[0].text, colums[1].text, colums[2].text, colums[3].css("img")[0]['src'], colums[4].text )
				setsql("insert into jb46o_finance_event values(null,'"+start.strftime("%Y%m%d")+"','"+f_event.time+"','"+f_event.region+"','"+f_event.city+"','"+f_event.weight+"','"+f_event.event+"')")
			end
		end

		# puts "获取休假信息..."
		rows =  f_rest_seg.css("tr")

		setsql('DELETE FROM jb46o_market_holiday where date="'+start.strftime("%Y%m%d")+'"')

		rows.each do | row |
			colums = row.css("td")
			rs = colums[0]['colspan']
			if rs.to_i.to_s != rs #排除没有的情况
				f_rest = MarketHoliday.new(colums[0].text, colums[1].text, colums[2].text, colums[3].text.gsub(/\s+/,''), colums[4].text.gsub(/\s+/,''))
				setsql("insert into jb46o_market_holiday values(null,'"+start.strftime("%Y%m%d")+"','"+f_rest.time+"','"+f_rest.region+"','"+f_rest.market+"','"+f_rest.holiday+"','"+f_rest.plan+"')")
			end
		end
	end
end

#获取URL中的参数
def getParam(url)
	parr = url.split("?")
	paramStr = ""
	if parr[1]
		paramStr = parr[1]
	end

	if paramStr != ""
		params = Hash.new("params")
		pas = paramStr.split("&")
		pas.each do |param|
			pa = param.split("=")
			params[pa[0]] = pa[1]
		end

		return params
	else
		return nil
	end
end

#get now timestamp
def getTimestamp
	now = Time.now
	return now.to_datetime.strftime '%Q'
end

#获取解读数据
def getInterprete(dataid)
	url = URI.parse('http://rili.jin10.com/jieduData.php')
	interprete = ''

	Net::HTTP.start(url.host, url.port) do |http|
		req = Net::HTTP::Post.new(url.path)
		req.set_form_data({ 'dataid' => dataid, 'datetime' => getTimestamp })
		interprete = http.request(req).body
	end

	if interprete != ''
		page = Nokogiri::HTML(interprete) do |config|
			config.noblanks.strict.nonet
		end

		title = page.css("[@class='cjrl_jdtop']").text
		content = page.css("div[@class='cjrl_jdyh'] ul li")
		nextPubDate = content[0].css("span")[1]?content[0].css("span")[1].text : ''
		dataAgent = content[1].css("span")[1]?content[1].css("span")[1].text : ''
		frequency = content[2].css("span")[1]?content[2].css("span")[1].text : ''
		statistic = content[3].css("span")[1]?content[3].css("span")[1].text : ''

		# puts title, nextPubDate, dataAgent, frequency, statistic
		dataAgent = content[1].inner_text.to_s
		dataAgent = dataAgent[7, dataAgent.length]

		frequency = content[2].inner_text.to_s
		frequency = frequency[5, frequency.length]

		statistic = content[3].inner_text.to_s
		statistic = statistic[5, statistic.length]

		#数据影响中有特殊字符(<, >), 使用正则匹配
		regex = /\<div class="cjrl_jdnr"\>(.*?)\<\/div\>/
		str = regex.match(interprete.to_s)

		datas = interprete.scan(regex)

		dataEffect = datas.at(0)?datas.at(0).at(0).force_encoding("utf-8"):""
		dataDefinition = datas.at(1)?datas.at(1).at(0).force_encoding("utf-8"):""
		concernReason = datas.at(2)?datas.at(2).at(0).force_encoding("utf-8"):""

		return Interpreter.new(title, nextPubDate, dataAgent, frequency, statistic, dataEffect, dataDefinition, concernReason)
	end

	return Interpreter.new()
end

def getGraphDatas(datanameid)
	uri = URI.parse(URI.escape('http://rili.jin10.com/getdata.php?datanameid='+datanameid+'&date='+getTimestamp+'&type=1'))
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)  
    response = http.request(request)  

	#把response.body 转换成JSON对象。
	result = JSON.parse(response.body).to_s
	return result
end

def checkExits(param, table)
	keys = param.keys
	where = ''
	for i in 0..keys.length-2
		where += keys[i] + "='" + param[keys[i]] + "' and "
	end
	where << keys[keys.length-1].to_s + "='" + param[keys[keys.length-1]] + "';"

	result = setsql("select count(*) as count from " + table + " where " + where)

	result.each do |res|
		return res["count"]
	end
end


now = Time.now
current =  Date.new(now.year, now.month, now.day)
crawler(current)
