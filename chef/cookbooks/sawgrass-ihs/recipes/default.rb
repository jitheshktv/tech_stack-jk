node.override['ihs']['instance_port'] = '10000'
node.override['ihs']['instance_name'] = 'https-sawgrass-web-03'
node.override['ihs']['instance_root'] =  "/apps/ihs-apps/#{node['ihs']['instance_name']}"
node.override['ihs']['conf_dir'] = "/apps/ihs-apps/#{node['ihs']['instance_name']}/conf"
node.override['ihs']['log_dir'] = "/apps/ihs-apps/#{node['ihs']['instance_name']}/logs"
node.override['ihs']['log_root'] = "/apps/ihs-apps/#{node['ihs']['instance_name']}/logs"
node.override['ihs']['key_file'] = "/apps/ihs-apps/#{node['ihs']['instance_name']}/conf/Sawgrass.kdb"
node.override['ihs']['stash_file'] = "/apps/ihs-apps/#{node['ihs']['instance_name']}/conf/Sawgrass.sth"

include_recipe 'sawgrass-ihs::setup' if node['feature_flags'].nil? || node['feature_flags']['include_setup']
include_recipe 'sawgrass-ihs::files_from_package_server' if node['feature_flags'].nil? || node['feature_flags']['include_content_server']

include_recipe 'IHS-AWS-Discovery-IBM-Packages::default'
include_recipe 'IHS-AWS-Discovery-IBM-Packages::install_ihs'

# # echo "Running Cookbooks to install Siteminder WebAgent ........"
# # chef-solo -j /apps/fe-tar-ball/cookbooks/WebAgent-AWS-Discovery-Citi/jsons/smwa_install.json
# # echo "Running Cookbooks to Register Webagent with Siteminder Policy Server ........."
# # chef-solo -j /apps/fe-tar-ball/cookbooks/WebAgent-AWS-Discovery-Citi/jsons/register_webagent.json

include_recipe 'IHS-AWS-Discovery-IBM-Packages::create_ihs_instance'
