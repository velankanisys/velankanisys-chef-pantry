
#UCS
default[:pxe][:ucs][:ip] = '192.168.73.131'
default[:pxe][:ucs][:username] = 'admin'
default[:pxe][:ucs][:password] = 'admin'


#DHCP
default[:pxe][:dhcpd][:dns_server] = "192.168.73.2"
default[:pxe][:dhcpd][:next_server] = "192.168.73.136"
default[:pxe][:dhcpd][:subnet] = "192.168.73.0"
default[:pxe][:dhcpd][:subnet_mask] = "255.255.255.0"
default[:pxe][:dhcpd][:broadcast] = "192.168.73.255"
default[:pxe][:dhcpd][:gateway] = "192.168.73.2"
default[:pxe][:dhcpd][:host_range] = "192.168.73.150 192.168.73.200"
default[:pxe][:dhcpd][:interfaces] = ['eth0']
default[:pxe][:dhcpd][:filename] = "pxelinux.0"
default[:pxe][:dhcpd][:databag] = "dhcpd"


#OS/Hypervisor auth info 
default[:pxe][:preseed][:username] = "chef"
default[:pxe][:preseed][:password] = "chef101"


#Ubuntu
default[:pxe][:os][:release] = "ubuntu-12.04.1"
default[:pxe][:linux][:release][:dist] = "ubuntu-12.04.1"
default[:pxe][:linux][:release][:path] = "http://mirror.anl.gov/pub/ubuntu-iso/CDs/12.04/ubuntu-12.04.1-server-amd64.iso"

#Debian
# default[:pxe][:os][:release] = "debian-6.0.6"
# default[:pxe][:linux][:release][:dist] = "debian-6.0.6"
# default[:pxe][:linux][:release][:path] = "http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-6.0.6-amd64-CD-1.iso"
# default[:pxe][:linux][:release][:netboot_path] = "http://ftp.nl.debian.org/debian/dists/squeeze/main/installer-amd64/current/images/netboot/netboot.tar.gz"
default[:pxe][:linux][:release][:keyring_path] = "http://mirror/debian-archive-keyring.gpg"

#ESXi - please rename VMware-VMvisor-Installer-5.1.0-799733.x86_64.iso to esxi-5.1.0.iso under /tmp
# default[:pxe][:esxi][:release] = "esxi-5.1.0"
# default[:pxe][:esxi][:path] = "http://example.com/VMware-VMvisor-Installer-5.1.0-799733.x86_64.iso"

# #Suse Linux
# default[:pxe][:os][:release] = "SLES-11-SP2"
# default[:pxe][:linux][:release][:dist] = "SLES-11-SP2"
# default[:pxe][:linux][:release][:path] = "http://example.com/SLES-11-SP2-DVD-x86_64-GM-DVD1.iso"
