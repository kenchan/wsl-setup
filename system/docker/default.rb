if node[:platform] == 'gentoo'
  include_recipe 'rootless.rb'
else
  package 'docker'

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

  service 'docker' do
    action [:enable, :start]
  end
end
