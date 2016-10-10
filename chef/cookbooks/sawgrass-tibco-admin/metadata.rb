name             'sawgrass-tibco-admin'
maintainer       'Citi AWS PoC Team'
maintainer_email 'citi_aws_poc@citi.com'
license          'All rights reserved'
description      'Installs/Configures Tibco'
long_description 'this is me'
version          '0.0.1'

depends 'gcb_chef_cookbook-tibco_osgold'
depends 'gcb_chef_cookbook-tibco_createhome'

depends 'gcb_chef_cookbook-tibco_rv'
depends 'gcb_chef_cookbook-tibco_tra'
depends 'gcb_chef_cookbook-tibco_hawk'
depends 'gcb_chef_cookbook-tibco_jmsclient'
depends 'gcb_chef_cookbook-tibco_dbclient'

depends 'gcb_chef_cookbook-tibco_administrator'
depends 'gcb_chef_cookbook-tibco_createdomaindbems' #(RDS should be created prior to this, along with EMS instance)
