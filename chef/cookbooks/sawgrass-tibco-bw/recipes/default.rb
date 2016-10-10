include_recipe 'sawgrass-tibco-bw::setup' if node['feature_flags'].nil? || node['feature_flags']['include_setup'] && node['feature_flags']['include_content_server']

include_recipe 'gcb_chef_cookbook-tibco_osgold::default'
include_recipe 'gcb_chef_cookbook-tibco_createhome::default'

include_recipe 'gcb_chef_cookbook-tibco_rv'
include_recipe 'gcb_chef_cookbook-tibco_tra'
include_recipe 'gcb_chef_cookbook-tibco_hawk'
include_recipe 'gcb_chef_cookbook-tibco_jmsclient'
include_recipe 'gcb_chef_cookbook-tibco_dbclient'

include_recipe 'gcb_chef_cookbook-tibco_bw'
include_recipe 'gcb_chef_cookbook-tibco_bwplugincopybook'
include_recipe 'gcb_chef_cookbook-tibco_sdk'
include_recipe 'gcb_chef_cookbook-tibco_adldap'
include_recipe 'gcb_chef_cookbook-tibco_bwcerts'
include_recipe 'gcb_chef_cookbook-tibco_mqclient'
include_recipe 'gcb_chef_cookbook-tibco_mwcconfig'

include_recipe 'sawgrass-tibco-bw::integration' if node['feature_flags'].nil? || node['feature_flags']['include_integration']

include_recipe 'gcb_chef_cookbook-tibco_addmachinedbems' if node['feature_flags'].nil? || node['feature_flags']['include_integration']
include_recipe 'gcb_chef_cookbook-tibco_caddie' if node['feature_flags'].nil? || node['feature_flags']['include_integration']
include_recipe 'gcb_chef_cookbook-tibco_caddiestub' if node['feature_flags'].nil? || node['feature_flags']['include_integration']
