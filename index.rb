require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'mysql'

PAGE_URL = "http://rili.jin10.com/index.php"


FinanceData     = Struct.new(:time, :region, :quota, :weight, :former_value, :predict_value, :public_value, :interprete)
FinanceEvent    = Struct.new(:time, :region, :city, :weight, :event)
MarketHoliday   = Struct.new(:time, :region, :market, :holiday, :plan)

#连接数据库本机：用户名：root 密码：sa 数据库：makedish 端口：3306  
  
# def setsql(sql)
# 	db = Mysql.init  
# 	db.options(Mysql::SET_CHARSET_NAME, 'utf8') 
# 	dbh = Mysql.real_connect("192.168.99.199", "root", "123456","cjrl", 3306)
# 	dbh.query("SET NAMES utf8")  
# 	dbh.query(sql);
# end
 
def crawler(start)

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
			# setsql('DELETE FROM jb46o_finance_data where date="'+start.strftime("%Y%m%d")+'"')
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
				# setsql("insert into jb46o_finance_data values(null,'"+start.strftime("%Y%m%d")+"','"+f_data.time+"','"+f_data.region+"','"+f_data.quota+"','"+f_data.weight+"','"+f_data.former_value+"','"+f_data.predict_value+"','"+f_data.public_value+"')")
				params = getParam(f_data.interprete)
				
				page = Nokogiri::HTML(open(url)) do |config|
					config.noblanks.strict.nonet
				end
			end
		end

		# puts "获取财经事件..."
		rows =  f_event_seg.css("tr")

		# setsql('DELETE FROM jb46o_finance_event where date="'+start.strftime("%Y%m%d")+'"')
		rows.each do | row |
			colums = row.css("td")
			rs = colums[0]['colspan']
			if rs.to_i.to_s != rs #排除没有的情况
				f_event = FinanceEvent.new(colums[0].text, colums[1].text, colums[2].text, colums[3].css("img")[0]['src'], colums[4].text )
				# setsql("insert into jb46o_finance_event values(null,'"+start.strftime("%Y%m%d")+"','"+f_event.time+"','"+f_event.region+"','"+f_event.city+"','"+f_event.weight+"','"+f_event.event+"')")
			end
		end

		# puts "获取休假信息..."
		rows =  f_rest_seg.css("tr")

		# setsql('DELETE FROM jb46o_market_holiday where date="'+start.strftime("%Y%m%d")+'"')

		rows.each do | row |
			colums = row.css("td")
			rs = colums[0]['colspan']
			if rs.to_i.to_s != rs #排除没有的情况
				f_rest = MarketHoliday.new(colums[0].text, colums[1].text, colums[2].text, colums[3].text.gsub(/\s+/,''), colums[4].text.gsub(/\s+/,''))
				# setsql("insert into jb46o_market_holiday values(null,'"+start.strftime("%Y%m%d")+"','"+f_rest.time+"','"+f_rest.region+"','"+f_rest.market+"','"+f_rest.holiday+"','"+f_rest.plan+"')")
			end
		end
	end
end

#get parameters from url
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

		title = page.css("[@class='cjrl_jdtop']")
		puts title
	end
end

now = Time.now
current =  Date.new(now.year, now.month, now.day)

crawler(current)
