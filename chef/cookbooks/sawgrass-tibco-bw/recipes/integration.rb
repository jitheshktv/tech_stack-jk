node.override['createdomain-dbems']['config']['ems_server_url'] = "#{node['createdomain-dbems']['config']['ems_server_ip']}:#{node['createdomain-dbems']['config']['ems_server_port']}"

bash 'allow access to the database' do
  flags '-x'
  code <<END
region=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\\" '{print $4}' | tr -d '\n')
export AWS_DEFAULT_REGION="${region}"
this_sg="#{node['addmachine-dbems']['config']['tibco_security_group_id']}"
rds_sg="#{node['addmachine-dbems']['config']['db_security_group']}"
rds_port="#{node['addmachine-dbems']['config']['db_port']}"
existing_rule_count=$(aws ec2 describe-security-groups --filters Name=group-id,Values=${rds_sg} Name=ip-permission.group-id,Values=${this_sg} Name=ip-permission.from-port,Values=${rds_port} Name=ip-permission.to-port,Values=${rds_port} | jq '.SecurityGroups | length')
if [[ "${existing_rule_count}" = "0" ]]; then
  aws ec2 authorize-security-group-ingress --group-id ${rds_sg} --protocol tcp --port ${rds_port} --source-group ${this_sg}
fi
END
end
