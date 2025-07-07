if node[:platform] == 'gentoo'
  package 'app-containers/docker'
else
  package 'docker'
end

directory "/etc/docker"

remote_file "/etc/docker/daemon.json" do
  source "files/etc/docker/daemon.json"
end

file "/etc/subuid" do
  action :edit
  block do |content|
    if content.include?("dockremap")
      content.sub!(/dockremap:\d+:\d+/, "dockremap:1000:65536")
    else
      content << "dockremap:1000:65536"
    end
  end
end

file "/etc/subgid" do
  action :edit
  block do |content|
    if content.include?("dockremap")
      content.sub!(/dockremap \d+:\d+/, "dockremap:1000:65536")
    else
      content << "dockremap:1000:65536"
    end
  end
end

execute "gpasswd -a #{ENV['SUDO_USER']} docker" do
  not_if "groups #{ENV['SUDO_USER']} | grep -q docker"
end

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
