require 'rubygems'
require 'apachelogregex'
require 'user_agent_type'

class MobileReportParser

	def init ( format , userAgentTypes )
		if format == nil
			@logparser = ApacheLogRegex.new( "'%{JiveClientIP}i %l %u %t \"%r\" %>s %b %T %k \"%{Referer}i\" \"%{User-Agent}i\" \"%{Content-Type}o\" %{JSESSIONID}C' %F")	
		else
			@logparser = ApacheLogRegex.new( format )
		end
		@userAgentTypes = Hash.new()
		userAgentTypes.each{ |type|
			@userAgentTypes[type] = 0
		}
		
		@browserview=0
		@ipadtabletview=0
		@androidtabletview=0
		@mobileview=0
		@iphone=0
		@android=0
		@blackberry=0
		@windows=0

	end

	def parsefile ( file )
		file.each { |line|
			unless line =~ /akamai|internal dummy connection|JiveServlet|deleteDraft|saveDraft|mod_ssl/
				parsedline = @logparser.parse(line)
				if parsedline
					contenttype = parsedline["%{Content-Type}o"]
					referer = parsedline["%{Referer}i"]
					useragent = parsedline["%{User-Agent}i"]

					@browserview += 1 if (contenttype =~ /text\/html/) && !(referer =~ /jive-mobile/) && !(useragent =~ /bot|crawler|spider/)
					@ipadtabletview +=1  if useragent =~ /iPad/
					@androidtabletview += 1 if (useragent =~ /Android/) && !(referer =~ /jive-mobile/)

					if contenttype =~ /application/ && referer =~ /jive-mobile/
						@mobileview += 1
						@iphone += 1 if useragent =~ /iPhone/
						@android += 1 if useragent =~ /Android/
						@blackberry += 1 if useragent =~ /BlackBerry/
						@windows += 1 if useragent =~ /Windows Phone/
					end
				end
			end	
		}
	end

	def printCounts()
		puts "Total Browser Pageviews #{@browserview}"
		puts "\tiPad #{@ipadtabletview}"
		puts "\tAndroid Tablet #{@androidtabletview}"
		puts "Total Mobile Pageviews #{@mobileview}"
		puts "\tiPhone #{@iphone}"
		puts "\tAndroid #{@android}"
		puts "\tWindows Phone #{@windows}"
		puts "\tBlackberry #{@blackberry}"
	end

end
