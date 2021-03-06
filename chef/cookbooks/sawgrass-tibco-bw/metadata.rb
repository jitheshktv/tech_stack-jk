name             'sawgrass-tibco-bw'
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

depends 'gcb_chef_cookbook-tibco_bw'
depends 'gcb_chef_cookbook-tibco_bwplugincopybook'
depends 'gcb_chef_cookbook-tibco_sdk'
depends 'gcb_chef_cookbook-tibco_adldap'
depends 'gcb_chef_cookbook-tibco_bwcerts'
depends 'gcb_chef_cookbook-tibco_mqclient'
depends 'gcb_chef_cookbook-tibco_mwcconfig'
depends 'gcb_chef_cookbook-tibco_addmachinedbems' #(Create domain should be done prior to this)
depends 'gcb_chef_cookbook-tibco_caddie'
depends 'gcb_chef_cookbook-tibco_caddiestub'
