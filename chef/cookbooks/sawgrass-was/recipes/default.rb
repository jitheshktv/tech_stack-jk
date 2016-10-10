log "YO!!! DMGR HOST is #{node['wsi']['dmgr_host_name']}"

node.override['wsi']['node1_profile_name'] = 'SawgrassNode1Profile'
node.override['wsi']['node1_cell_name'] = 'SawgrassNode1Cell'
node.override['wsi']['node1_node_name'] = 'SawgrassNode1'

include_recipe 'sawgrass-was::setup' if node['feature_flags'].nil? || node['feature_flags']['include_setup']
include_recipe 'sawgrass-was::files_from_package_server' if node['feature_flags'].nil? || node['feature_flags']['include_content_server']

#iam_was_install
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::create-user-group'
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::createdirectories'
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::install_iim_was'

#create_node_profile
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::create_node_profile'

#add_node
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::add_node' if node['feature_flags'].nil? || node['feature_flags']['include_integration']
