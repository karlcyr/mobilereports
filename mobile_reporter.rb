#!/usr/bin/ruby

require 'parser'

format = '%{JiveClientIP}i %l %u %t \"%r\" %>s %b %T %k \"%{Referer}i\" \"%{User-Agent}i\" \"%{Content-Type}o\" %{JSESSIONID}C'

logparser = MobileReportParser.new( )
logparser.init( format, [] )
logparser.parsefile($<) 

logparser.printCounts()
