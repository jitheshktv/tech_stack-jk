#!/bin/bash
usage()
{
	echo "usage : $0"
}

installRpm()
{
	product=$1
	rpm=$2

#	if [ ! -z $rpm ]; then
	        rpm -ivh --replacepkgs $rpm
	        RC=$?
	        if [ $RC -eq 0 ]; then
	                echo "$product rpm has been installed successfully"
	                rm $rpm
	        else
	                echo "Error in installing the $product rpm"
	                exit 1
	        fi
#	fi
}

#Main starts here...

rpm_source=https://s3.amazonaws.com/citi-tibco/install/rpms
rpm_jdk_source=$rpm_source/jdk
rpm_jre_source=$rpm_source/jre
rpm_nfs_source=$rpm_source/nfs
rpm_ora_source=$rpm_source/ora

OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
#VER=$(lsb_release -sr)
VER=`echo $(lsb_release -sr) | awk -F"." '{print $1}'`

if [ $OS == "RedHatEnterpriseServer" ] && [ $ARCH -eq 64 ] && [ $VER -eq 5 ]; then
	rpm_chef=chef-12.9.41-1.el5.x86_64.rpm
	rpm_chef_target=/tmp/$rpm_chef

	rpm_jdk=jdk-8u92-linux-x64.rpm
	rpm_jdk_target=/tmp/$rpm_jdk

        rpm_jre=jre-8u92-linux-x64.rpm
        rpm_jre_target=/tmp/$rpm_jre

	rpm_nfs_source=$rpm_nfs_source/5.x
	rpm_nfs_libevent=libevent-1.4.13-1.x86_64.rpm
	rpm_nfs_libevent_target=/tmp/$rpm_nfs_libevent
	rpm_nfs_libgssapi=libgssapi-0.10-2.x86_64.rpm
	rpm_nfs_libgssapi_target=/tmp/$rpm_nfs_libgssapi
        rpm_nfs_utils=nfs-utils-1.0.9-71.el5_11.x86_64.rpm
	rpm_nfs_utils_target=/tmp/$rpm_nfs_utils
        rpm_nfs_utilslib=nfs-utils-lib-1.0.8-7.9.el5.x86_64.rpm
	rpm_nfs_utilslib_target=/tmp/$rpm_nfs_utilslib
        rpm_nfs_portmap=portmap-4.0-65.2.2.1.x86_64.rpm
	rpm_nfs_portmap_target=/tmp/$rpm_nfs_portmap

	rpm_ora_basic=oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
	rpm_ora_basic_target=/tmp/$rpm_ora_basic
	rpm_ora_sqlplus=oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
	rpm_ora_sqlplus_target=/tmp/$rpm_ora_sqlplus

	# Download JDK RPM
        curl $rpm_jdk_source/$rpm_jdk --output $rpm_jdk_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "jdk rpm has been downloaded successfully"
        else
                echo "Error in downloading the jdk rpm"
                exit 1
        fi

	# Download JRE RPM
        curl $rpm_jre_source/$rpm_jre --output $rpm_jre_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "jre rpm has been downloaded successfully"
        else
                echo "Error in downloading the jre rpm"
                exit 1
        fi

	#Download NFS RPMS
        curl $rpm_nfs_source/$rpm_nfs_libevent --output $rpm_nfs_libevent_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "nfs libevent rpm has been downloaded successfully"
        else
                echo "Error in downloading the nfs libevent rpm"
                exit 1
        fi

        curl $rpm_nfs_source/$rpm_nfs_libgssapi --output $rpm_nfs_libgssapi_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "nfs libgssapi rpm has been downloaded successfully"
        else
                echo "Error in downloading the nfs libgssapi rpm"
                exit 1
        fi

	curl $rpm_nfs_source/$rpm_nfs_utils --output $rpm_nfs_utils_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "nfs utils rpm has been downloaded successfully"
        else
                echo "Error in downloading the nfs utils rpm"
                exit 1
        fi

	curl $rpm_nfs_source/$rpm_nfs_utilslib --output $rpm_nfs_utilslib_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "nfs utilslib rpm has been downloaded successfully"
        else
                echo "Error in downloading the nfs utilslib rpm"
                exit 1
        fi

        curl $rpm_nfs_source/$rpm_nfs_portmap --output $rpm_nfs_portmap_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "nfs portmap rpm has been downloaded successfully"
        else
                echo "Error in downloading the nfs portmap rpm"
                exit 1
        fi

	# Downloading Oraclient RPMs.
        curl $rpm_ora_source/$rpm_ora_basic --output $rpm_ora_basic_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "ora basic rpm has been downloaded successfully"
        else
                echo "Error in downloading the ora basic rpm"
                exit 1
        fi

	curl $rpm_ora_source/$rpm_ora_sqlplus --output $rpm_ora_sqlplus_target --silent
        RC=$?
        if [ $RC -eq 0 ]; then
                echo "ora sqlplus rpm has been downloaded successfully"
        else
                echo "Error in downloading the ora sqlplus rpm"
                exit 1
        fi
fi

# install jdk rpm
installRpm jdk $rpm_jdk_target

# install jre rpm
installRpm jre $rpm_jre_target

# install nfs rpms
installRpm nfs_libevent $rpm_nfs_libevent_target
installRpm nfs_libgssapi $rpm_nfs_libgssapi_target
installRpm nfs_portmap $rpm_nfs_portmap_target
installRpm nfs_utils "$rpm_nfs_utils_target $rpm_nfs_utilslib_target"

# Install the oracle client rpms
installRpm OracleClient $rpm_ora_basic_target
installRpm OracleClient $rpm_ora_sqlplus_target
