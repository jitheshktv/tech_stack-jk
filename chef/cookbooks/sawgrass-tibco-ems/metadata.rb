name             'sawgrass-tibco-ems'
maintainer       'Citi AWS PoC Team'
maintainer_email 'citi_aws_poc@citi.com'
license          'All rights reserved'
description      'Installs/Configures Tibco'
long_description 'this is me'
version          '0.0.1'

depends 'gcb_chef_cookbook-tibco_osgold'
depends 'gcb_chef_cookbook-tibco_createhome'

depends 'gcb_chef_cookbook-tibco_ems'
depends 'gcb_chef_cookbook-tibco_emscreateinstance'
