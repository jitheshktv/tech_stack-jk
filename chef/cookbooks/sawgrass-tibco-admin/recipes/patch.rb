bash 'copy tibrv license file' do
  ignore_failure true
  flags '-x'
  code <<END
tibco_install_dir="#{node['rv-install']['install']['tibco_install_dir']}"
rv_major_version="#{node['rv-install']['install']['rv_major_version']}"
rv_home_dir="${tibco_install_dir}/tibrv/${rv_major_version}"
cp ${rv_home_dir}/bin/tibrvtkt.smp ${rv_home_dir}/bin/tibrv.tkt
END
end
