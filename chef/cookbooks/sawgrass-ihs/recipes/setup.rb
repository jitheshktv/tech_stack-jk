
#package 'perl'

bash 'format file systems' do
  flags '-e -x'
  code <<END
yes | /sbin/mkfs -t ext3 /dev/sdf
yes | /sbin/mkfs -t ext3 /dev/sdk
mkdir /apps /logs || true
mount /dev/sdf /apps
mount /dev/sdk /logs
echo "/dev/sdf                /apps                   ext3    defaults        1 1" >>  /etc/fstab
echo "/dev/sdk                /logs                   ext3    defaults        1 1" >>  /etc/fstab
END
end

include_recipe 'sawgrass-ihs::files_from_package_server'

bash 'Updating network and host files' do
  flags '-e -x'
  code <<END
hostname=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
perl -pi -e 's/localhost.localdomain/'$hostname'/g' /etc/sysconfig/network
perl -pi -e 's/localhost.localdomain localhost/'$hostname'.localdomain '$hostname' localhost localhost.localdomain/g' /etc/hosts
hostname $hostname
service network restart
END
end

bash 'Switching off iptables' do
  flags '-x'
  code <<END
/etc/init.d/iptables stop
chkconfig iptables off
END
end
