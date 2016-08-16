#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
repo --name="Server-HighAvailability" --baseurl=file:///run/install/repo/addons/HighAvailability
repo --name="Server-ResilientStorage" --baseurl=file:///run/install/repo/addons/ResilientStorage
# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=em1 --onboot=off --ipv6=auto
network  --bootproto=dhcp --device=em2 --onboot=off --ipv6=auto
network  --bootproto=static --device=em3 --gateway=172.21.15.254 --ip=172.21.1.113 --nameserver=172.21.0.10 --netmask=255.255.240.0 --noipv6 --activate
network  --bootproto=dhcp --device=em4 --onboot=off --ipv6=auto
network  --bootproto=dhcp --device=p3p1 --onboot=off --ipv6=auto
network  --bootproto=dhcp --device=p3p2 --onboot=off --ipv6=auto
network  --hostname=refarch-r730xd-01.front.sepia.ceph.com

# Root password
rootpw --iscrypted $6$u5HREhM7uZD57wg7$j.RSAXZdu8/YAakT8Xpf6tLLGXqzs3iiS8nonQoSURVpZPY0.ZOurfHSzigisIoSL.KVrP3APtPsjucmX5.y8.
# System services
services --enabled="chronyd"
# System timezone
timezone America/New_York --isUtc --ntpservers=0.rhel.pool.ntp.org,1.rhel.pool.ntp.org,2.rhel.pool.ntp.org,3.rhel.pool.ntp.org,clock.redhat.com
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part pv.361 --fstype="lvmpv" --ondisk=sda --size=475391
part /boot --fstype="xfs" --ondisk=sda --size=1024
volgroup vg_root --pesize=4096 pv.361
logvol /var/log  --fstype="xfs" --size=20480 --label="LOG" --name=lv_log --vgname=vg_root
logvol /  --fstype="xfs" --size=446720 --label="ROOT" --name=lv_root --vgname=vg_root
logvol swap  --fstype="swap" --size=8188 --name=lv_swap --vgname=vg_root

%packages
@^minimal
@core
chrony
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end
