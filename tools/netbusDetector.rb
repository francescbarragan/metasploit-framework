#netbus ruby detector
#Pablo

require 'socket'

def sendKeys(s)
	if s
		s.write "SendKeys;0;pablo!\r"
		puts
		puts "Sent!"
		puts
	else
		puts "No Open Socket"
		puts
	end
end

def getInfo(s)
	if s
		s.write "GetInfo\r"
		r = s.gets("\r")
		r.gsub!(";","\n")
		r.gsub!("|","\n")
		puts
		puts r
		puts
	else
		puts "No Open Socket"
		puts
	end
end

def message(s)
	if s
		s.write "Message;0;Suprise!;Information;64;\r"
		respuesta = s.gets(19)
		r = s.gets("\r")
		puts
		puts (respuesta+r).gsub!(";","\n")
		puts
	else
		puts "No Open Socket"
		puts
	end
end

def files(s)
	if s
		s.write "GetDisks\r"
		disk = s.gets("\r");
		tam = disk.split(";")[1]
		puts disk
		s2 = TCPSocket.open('192.168.56.102',12346)
		lista = s2.gets(tam)
		puts
		puts lista
		puts
		s2.close
	else
		puts "No Open Socket"
		puts
	end
end

def showMenu
	puts "Menu netbusDetector"
	puts "==================="
	puts
	puts "0) Open Socket & Detect Netbus Version"
	puts "1) Send Keys"
	puts "2) Message Box"
	puts "3) Files"
	puts "4) Get Info"
	puts "c) Close Socket"
	puts "s) Exit"
	puts
end

def openSocket
	s = TCPSocket.open('192.168.56.102',6000)
	line = s.gets("\r")
	if line =~ /NetBus/
		puts
		puts "Version:#{line}"
		puts
	else
		return nil
	end
	return s
end

def closeSocket(s)
	if s
		s.close
		puts "Closed"
		return nil
	end
end

s = nil

begin
	
	showMenu
	print "Option:"
	opcion = gets.chomp
	
	case opcion
	when "0" then s = openSocket
	when "1" then sendKeys(s)
	when "2" then message(s)
	when "3" then files(s)
	when "4" then getInfo(s)
	when "c" then s = closeSocket(s)
	when "s" then puts "bye bye"
	when "S" then puts "bye bye"
	else puts "Really?? ouch!"
	end
	puts "ENTER..."
	gets
end while ((not opcion == "s")&&(not opcion == "S"))
