#package 'tar'

bash 'Transfering Files from Package Server' do
  flags '-e -x'
  code <<END
content_server_ip="#{node['content_server']['ip']}"
content_server_port="#{node['content_server']['port']}"
content_server_url=${content_server_ip}:${content_server_port}
mkdir /apps /logs || true
cd /apps
curl -o /apps/fe-tar-ball.tar  http://${content_server_url}/fe-tar-ball.tar
tar xvf fe-tar-ball.tar
END
end
