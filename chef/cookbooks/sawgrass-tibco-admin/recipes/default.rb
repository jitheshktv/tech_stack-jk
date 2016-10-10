include_recipe 'sawgrass-tibco-admin::setup' if node['feature_flags'].nil? || node['feature_flags']['include_setup'] && node['feature_flags']['include_content_server']

include_recipe 'gcb_chef_cookbook-tibco_osgold::default'
include_recipe 'gcb_chef_cookbook-tibco_createhome::default'

include_recipe 'gcb_chef_cookbook-tibco_rv'
include_recipe 'gcb_chef_cookbook-tibco_tra'
include_recipe 'gcb_chef_cookbook-tibco_hawk'
include_recipe 'gcb_chef_cookbook-tibco_jmsclient'
include_recipe 'gcb_chef_cookbook-tibco_dbclient'

include_recipe 'gcb_chef_cookbook-tibco_administrator'

include_recipe 'sawgrass-tibco-admin::patch'

include_recipe 'sawgrass-tibco-admin::integration' if node['feature_flags'].nil? || node['feature_flags']['include_integration']

include_recipe 'gcb_chef_cookbook-tibco_createdomaindbems' if node['feature_flags'].nil? || node['feature_flags']['include_integration']
