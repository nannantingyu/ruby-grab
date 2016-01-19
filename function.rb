require 'date'
require 'nokogiri'
require 'net/http'
require 'json'

Interpreter = Struct.new(:title, :nextPubDate, :dataAgent, :frequency, :statistic, :dataEffect, :dataDefinition, :concernReason)

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

def getTimestamp
	now = Time.now
	return now.to_datetime.strftime '%Q'
end

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

		datas = page.css("div[@class='cjrl_jdnr']")
		dataEffect = datas[0].text
		dataDefinition = datas[1].text
		concernReason = datas[2].text

		return Interpreter.new(title, nextPubDate, dataAgent, frequency, statistic, dataEffect, dataDefinition, concernReason)
	end

	return Interpreter.new()
end

def getGraphDatas
	uri = URI.parse(URI.escape('http://rili.jin10.com/getdata.php?datanameid=645&date=1453171003000&type=1'))
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)  
    response = http.request(request)  

	#把response.body 转换成JSON对象。
	result = JSON.parse(response.body)
	puts result
end

inter = getInterprete(141708)
inter.each do |data|
	puts data
end

getGraphDatas