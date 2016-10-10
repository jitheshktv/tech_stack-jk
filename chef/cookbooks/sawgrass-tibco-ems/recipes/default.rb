node.override['ems-createinstance']['config']['ft'] = 'false'
node.override['ems-createinstance']['config']['isapp1'] = 'false'
node.override['ems-createinstance']['config']['isapp2'] = 'false'
node.override['ems-createinstance']['config']['isapp3'] = 'false'

include_recipe 'sawgrass-tibco-ems::setup' if node['feature_flags'].nil? || node['feature_flags']['include_setup'] && node['feature_flags']['include_content_server']

include_recipe 'gcb_chef_cookbook-tibco_osgold::default'
include_recipe 'gcb_chef_cookbook-tibco_createhome::default'

include_recipe 'gcb_chef_cookbook-tibco_ems::default'
include_recipe 'gcb_chef_cookbook-tibco_emscreateinstance::default'
