package 'docker'

package 'docker-compose'

if node[:platform] == 'gentoo'
  execute 'systemctl start docker' do
    not_if 'systemctl -q is-active docker'
  end

  execute 'systemctl enable docker' do
    not_if 'systemctl -q is-enabled docker'
  end
else
  service 'docker' do
    action [:enable, :start]
  end
end

