node.override['wsi']['dmgr_host_name'] = node['ipaddress']
node.override['wsi']['node1_profile_name'] = 'SawgrassNode1Profile'
node.override['wsi']['node1_cell_name'] = 'SawgrassNode1Cell'
node.override['wsi']['node1_node_name'] = 'SawgrassNode1'
node.override['wsi']['node1_cluster_name'] = 'SawgrassCluster'
node.override['wsi']['node1_server_name'] = 'Server1'
node.override['wsi']['node1_server02_name'] = 'Server2'

# be sure to override any derivatives of was/xxxxx

include_recipe 'sawgrass-was-dmgr::setup' if node['feature_flags'].nil? || node['feature_flags']['include_setup']
include_recipe 'sawgrass-was-dmgr::files_from_package_server' if node['feature_flags'].nil? || node['feature_flags']['include_content_server']

include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::create-user-group'
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::createdirectories'
include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::install_iim_was'

include_recipe 'WAS-ND-AWS-Discovery-IBM-Packages::create_dmgr_profile'
