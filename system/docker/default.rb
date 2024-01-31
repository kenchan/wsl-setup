package 'docker'
package 'docker-compose'
package 'docker-buildx'

service 'docker' do
  action [:enable, :start]
end

execute "gpasswd -a #{ENV['SUDO_USER']} docker" do
  not_if "groups #{ENV['SUDO_USER']} | grep -q docker"
end
